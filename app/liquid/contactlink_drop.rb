
Comatose.define_drop "contactlink" do 
  extend ActionView::Helpers::TagHelper

  def before_method(method)
    contact = Contact.find_by_method_name(method)
    return "Contact not found" if contact.nil?
    linkopts = {:href => contact.href, :class => "url " + contact.fn_class}
    linkopts[:rel] = contact.xfn unless contact.xfn.nil? or contact.xfn.empty?
    link = content_tag('a', contact.fn, linkopts)
    content_tag('span', link, {:class => 'vcard'})
  end

end
