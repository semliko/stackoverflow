module ApplicationHelper
  def collaction_chache_key_for(model)
    klass = model.to_s.capitalize.constantanize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).tru(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
