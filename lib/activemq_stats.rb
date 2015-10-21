require 'net/http'
require 'nokogiri'

class ActiveMQStats
  attr_accessor :activemq_url, :activemq_user, :activemq_password

  def initialize(activemq_url, activemq_user, activemq_password)
    self.activemq_url = activemq_url
    self.activemq_user = activemq_user
    self.activemq_password = activemq_password
  end

  def request(queue_name)
    xml = Nokogiri::XML(request_queue_xml_data)
    queue_stats = queue_stats(xml.xpath("//queue[@name='#{queue_name}']/stats").first)
    QueueData.new(
      queue_name,
      queue_stats['size'].to_i,
      queue_stats['consumerCount'].to_i,
      queue_stats['enqueueCount'].to_i,
      queue_stats['dequeueCount'].to_i
    )
  end

  private

  def request_queue_xml_data
    queues_info_path = URI(File.join(activemq_url, 'admin/xml/queues.jsp'))
    Net::HTTP.start(queues_info_path.host, queues_info_path.port) do |http|
      request = Net::HTTP::Get.new queues_info_path.request_uri
      request.basic_auth(activemq_user, activemq_password)

      return http.request(request).body
    end
  end

  def queue_stats(stats_node)
    Hash[stats_node.attributes.map{ |key, value| [key, value.value ]}]
  end
end
