require 'odt_to_xhtml'

class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
	cnv = ODT_to_XHTML.new
	xmldata = cnv.get_html(@document.content, @document.styles)
	@head = xmldata[:head].get_text("style")
	@body = xmldata[:body].to_s.sub(/<body>/,"<div class=\"document\">").sub(/<\/body>/,"</div>")
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  def get_date(params_hash,field_name)
	DateTime.new(params_hash[field_name+"(1i)"].to_i,params_hash[field_name+"(2i)"].to_i,params_hash[field_name+"(3i)"].to_i,params_hash[field_name+"(4i)"].to_i,params_hash[field_name+"(5i)"].to_i)
  end
  
  def unpack_document(tmpfile)
	if !tmpfile.nil? then
	res = ""
	zf = Zip::File.new(tmpfile.path)
	styles = ""
	content = ""
	zf.each {
		|entry|
		if (entry.name == "styles.xml")	 then 
			styles = entry.get_input_stream.read
		end
		if (entry.name == "content.xml") then 
			content = entry.get_input_stream.read
		end
	}
	{:content => content, :styles => styles}
	end
  end
  # POST /documents
  # POST /documents.json
  def create
	  
	data = unpack_document(params[:document][:datafile])  
	doc_params = {:title => document_params["title"], :date => get_date(document_params,"date")}
	if !data.nil? then
		doc_params[:content] = data[:content]
		doc_params[:styles] = data[:styles]
	end
    @document = Document.new(doc_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render action: 'show', status: :created, location: @document }
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
	data = unpack_document(params[:document][:datafile])  
	doc_params = {:title => document_params["title"], :date => get_date(document_params,"date")}
	if !data.nil? then
		doc_params[:content] = data[:content]
		doc_params[:styles] = data[:styles]
	end
    respond_to do |format|
      if @document.update(doc_params)
        format.html { redirect_to @document, notice: "Document updated successfully"}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:title, :date, :content)
    end
end
