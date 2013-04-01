class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def filter
    tag = Tag.find(params[:tag_id])
    @products = tag.products
  end

  def search
      query = params[:query]
      @products = Product.where("name @@ :q or description @@ :q or image @@ :q or address @@ :q", :q => query)

      tags = Tags.where("name @@ :q", :q => query)

      @products += tags.map(&:products).flatten
      @products.uniq!

      render :filter
  end

  def create
    @product = Product.create(params[:product])
    tags = params[:tags].split(',')
    tags.each do |tag|
      tag = tag.squish
      t = Tag.where(name: tag).first
      t = Tag.new(name: tag) if t.nil?
      @product.tags << t
    end

    @products = Product.all
  end
end
