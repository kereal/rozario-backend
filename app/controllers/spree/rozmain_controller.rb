class Spree::RozmainController < Spree::StoreController
  before_action :set_headers

  
  def index
    
    products = Spree::Product.available.preload(master: :prices).order(created_at: :desc).limit(6).map { |p| {
      id: p.id,
      title: p.name,
      description: p.description,
      price: p.master.price.to_i,
      image: p.master.images.first.url,
      #hitItem: true,
      newItem: true,
      size: {
        name: 'средний', width: { num: '22', measureUnit: 'см' }, height: { num: '12', measureUnit: 'см' },
      },
    }}
    
    taxons = Spree::Taxon.find_by_id!(12).children.map { |t| {
      id: t.id,
      name: t.name,
      permalink: "/catalog/#{t.permalink}",
      image: t.icon.exists? ? t.icon(:large) : nil
    }}
    
    reviews = Spree::Review.preload(:order).published
    
    render json: {
      taxons: taxons,
      products: products,
      reviews: reviews
    }, include: { order: { only: :number }}
    
  end
  
  
  # GET /catalog/:permalink (/catalog/collections/podarki)
  def category
  
    taxons = Spree::Taxon.find_by_id!(22).children.map { |t| {
      id: t.id,
      name: t.name,
      permalink: "/catalog/#{t.permalink}",
    }}
    
    products = Spree::Product.joins(:taxons)
      .where(taxons:{permalink: params[:permalink]})
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
      taxons: taxons,
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
    #reviews = Review.preload(:order).published
    #render json: {
    #  reviews: reviews
    #}, include: {
    #  order: { only: :number }
    #}
  end
  
  
  protected
  
    def set_headers
      response.set_header('Access-Control-Allow-Origin', '*')
    end

end
