module NixHelpers
  def parse_service_status(service_status_output)
    working_services = service_status_output.lines.select { |line| line.include? 'RUNNING' }.collect { |l| l.strip.split.first }
    failing_services = service_status_output.lines.reject { |line| line.include? 'RUNNING' }.collect { |l| l.strip.split.first }

    OpenStruct.new working_services: working_services,
                   failing_services: failing_services,
                   all_services_down?: failing_services.present? && !working_services.present?,
                   all_services_up?: !failing_services.present? && working_services.present?,
                   some_services_down?: failing_services.present? && working_services.present?,
                   some_services_up?: failing_services.present? && working_services.present?

  end

  def service_status_to_bot_message(service_status)
    if service_status.all_services_down?
      ['all services are DOWN:', status]

    elsif parsed_status.all_services_up?
      ['all services are RUNNING:', status]

    elsif parsed_status.some_services_down?
      ["some services are DOWN: #{parsed_status.failing_services.join(', ')}", status]

    else
      ['not sure how to interpret these results:', status]
    end
  end
end