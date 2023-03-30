class Spree::RozmainController < Spree::StoreController
  before_action :set_headers

  
  def index

    root_permalinks = ['povod', 'komu', 'type']
    taxon_list = Spree::Taxon.where(permalink: root_permalinks).preload(:children)
    #.select(:id, :name, :permalink)
    
    root_taxons = {}
    root_permalinks.each do |permalink|
      root_taxons[permalink.to_sym] = taxon_list
          .select{ |t| t.permalink == permalink }[0].children.map { |t| {
            id: t.id,
            name: t.name,
            permalink: t.permalink,
          }}
    end
    
    products = Spree::Product.available.preload(master: :prices).order(created_at: :desc).limit(6).map { |p| {
      id: p.id,
      title: p.name,
      description: p.description,
      price: p.master.price,
      image: p.master.images.first.url,
      "#{[true, false].sample ? 'hitItem' : 'newItem'}": true,
      size: { name: 'средний', width: { num: '22', measureUnit: 'см' }, height: { num: '12', measureUnit: 'см' }},
    }}
    
    collections = Spree::Taxon.find_by!(permalink: 'collections').children.first(6).map { |t| {
      id: t.id,
      name: t.name,
      permalink: "/catalog/#{t.permalink}",
      image: t.icon.exists? ? t.icon(:large) : nil
    }}
    
    reviews = Spree::Review.select(:id, :order_id, :text, :reply, :rating, :created_at).preload(:order).published
    
    render json: {
      taxons: collections,
      root_taxons: root_taxons,
      products: products,
      reviews: reviews
    }, include: { order: { only: :number } }
    
  end
  
  
  # GET /catalog/:permalink (/catalog/collections/podarki)
  def category
  
    permalink_pieces = params[:permalink].split('/')
    # разрежем на части и если сначала идет collections, то не будет выдавать подкатегории
  
    taxons = Spree::Taxon.find_by_id!(22).children.map { |t| {
      id: t.id,
      name: t.name,
      permalink: "/catalog/#{t.permalink}",
    }} unless permalink_pieces[0] == 'collections'
    
    current_taxon = Spree::Taxon.select(:id, :name, :permalink).find_by(permalink: params[:permalink])
    
    products = Spree::Product.joins(:taxons)
      .where(taxons: { permalink: params[:permalink] })
      .preload(master: :prices).map { |p| {
        id: p.id,
        title: p.name,
        description: p.description,
        price: p.master.price,
        image: p.master.images.first.url,
        size: {
          name: 'средний', width: { num: '22', measureUnit: 'см' }, height: { num: '12', measureUnit: 'см' },
        }
    }}
    
    render json: {
      current_taxon: current_taxon,
      taxons: taxons || [],
      products: products
    }
    
  end

  
  # GET /catalog/product/:id
  def product
    product = Spree::Product.find_by!(id: params[:id])
    
    variants = product
        .variants_including_master
        .display_includes
        .with_prices(current_pricing_options)
        .includes([:option_values, :images])

    props = product.product_properties.includes(:property)
    
    variants = variants.map{ |v| {
      id: v.id,
      product_id: v.product_id,
      price: v.price,
      is_master: v.is_master,
      images: v.images.map(&:url)
    }}
    
    render json: {
      product: product,
      variants: variants,
      properties: props
    }
  end
  
  
  def reviews
  end
  
  
  protected
  
    def set_headers
      response.set_header('Access-Control-Allow-Origin', '*')
    end

end
