module ActsAsEnumable
  class Railtie < Rails::Railtie
    initializer 'acts_as_enumable.model_additions' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
  end
end