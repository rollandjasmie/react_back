class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :references, :references
end
