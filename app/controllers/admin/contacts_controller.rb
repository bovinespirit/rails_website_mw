require 'admin/authentication_module'

# New routes, functional testing

class Admin::ContactsController < ApplicationController
  include Authentication
  before_filter :authenticate, :set_webpage

  # GET /admin/contacts
  # GET /admin/contacts.xml
  def index
    @contacts = Contact.find(:all, :order => 'fn')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @contacts.to_xml }
    end
  end

  # GET /admin/contacts/1
  # GET /admin/contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @contact.to_xml }
    end
  end

  # GET /admin/contacts/new
  def new
    @contact = Contact.new
  end

  # GET /admin/contacts/1;edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /admin/contacts
  # POST /admin/contacts.xml
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to contact_url(@contact) }
        format.xml  { head :created, :location => contact_url(@contact) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors.to_xml }
      end
    end
  end

  # PUT /admin/contacts/1
  # PUT /admin/contacts/1.xml
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to contact_url(@contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors.to_xml }
      end
    end
  end

  # DELETE /admin/contacts/1
  # DELETE /admin/contacts/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  def set_webpage
    @webpage = Webpage.create('admin/contacts')
  end
end
