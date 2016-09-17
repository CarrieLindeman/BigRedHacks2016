class ItemsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def alexa_handler
    intent = params[:request][:intent][:name]
    if intent == 'ExpiresToday'
      @items = Item.where("expiration <= ?", Time.now).where(removed: false)
      item_list = @items.map { |item| item.name }.join(', ')
      if item_list.length < 1
        output_text = "Nothing is expiring today."
      else
        output_text = "You have #{pluralize(@items.count, 'thing')} expiring today. They are #{item_list}"
      end
    elsif intent == 'AddItem'
      @item = Item.new
      @item.name = params[:request][:intent][:slots][:Food][:value]
      @item.expiration = Date.parse(params[:request][:intent][:slots][:Date][:value])
      @item.removed = false
      @item.save
      output_text = "Got it. #{@item.name} expires on #{distance_of_time_in_words_to_now(@item.expiration)}"
    elsif intent == 'GetDate'
      input_name = params[:request][:intent][:slots][:Food][:value]
      items = Item.where("name like ?", "%input_name%").order(expiration: :asc)
      if items.length > 0
        the_item = items.first
        output_text = "Your #{the_item.name} expires in #{distance_of_time_in_words_to_now(the_item.expiration)}"
      else
        output_text = "Sorry, I couldn't find that item."
      end
    elsif intent == 'GetFoods'
      input_date = Date.parse(params[:request][:intent][:slots][:Date][:value])
      @items = Item.where("expiration <= ?", input_date).where(removed: false)
      item_list = @items.map { |item| item.name }.join(', ')
      if item_list.length < 1
        output_text = "Nothing is expiring before #{input_date.to_s}."
      else
        output_text = "You have #{pluralize(@items.count, 'thing')} expiring before #{input_date.to_s}. They are #{item_list}"
      end
    else
      output_text = "I don't know what to do."
    end
    j = {
				  "version" => "1.0",
					"response" => {
					  "outputSpeech" => {
					    "type" => "PlainText",
					    "text" => output_text
					  },
					  "card" => {
					    "type" => "Simple",
					    "title" => "Expiration Check",
					    "content" => output_text
					  },
  				  "reprompt" => {
  				    "outputSpeech" => {
  				      "type" => "PlainText",
  				      "text" => "Hello"
  				    }
  				  },
  				  "shouldEndSession" => true
  				}
  			}
    render json: j
  end

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :expiration, :removed)
    end
end
