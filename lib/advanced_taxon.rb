require 'spree_core'
require 'advanced_taxon_hooks'

module AdvancedTaxon
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Admin::TaxonsController.class_eval do
        def edit
          load_object
          unless request.get?
            if @taxon.update_attributes(params[:taxon])
              flash[:notice] = t('advanced_taxon.succesfully_updated')
              redirect_to edit_admin_taxonomy_url(@taxon.taxonomy)
            end
          end
        end
      end


      Taxon.class_eval do
        validates_presence_of :name
        has_attached_file :icon,
        :styles => { :mini => '32x32>', :normal => '128x128>' },
        :default_style => :mini,
        :url => "/assets/taxons/:id/:style/:basename.:extension",
        :path => ":rails_root/public/assets/taxons/:id/:style/:basename.:extension",
        :default_url => "/images/default_taxon.png"
      end

    end

    config.to_prepare &method(:activate).to_proc
  end
end
