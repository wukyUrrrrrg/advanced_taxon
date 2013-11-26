class AdvancedTaxonHooks < Spree::ThemeSupport::HookListener
  # custom hooks go here
  replace :taxon_products do 
    %(<% if !params.key?(:page) -%>
<%= @taxon.description.html_safe if @taxon and @taxon.description %>
<% end -%>
<%= render :partial => "shared/products", :locals => {:products => @products, :taxon => @taxon } %>
)
  end 

end
