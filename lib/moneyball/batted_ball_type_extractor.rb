module Moneyball
  class BattedBallTypeExtractor
    def initialize(event_description)
      @event_description = event_description
    end

    def classification
      case
      when event_description.match(/line(s)? (drive|into|out)/)
        "Line drive"
      when event_description.match(/fl(ies|y) (ball|out)/)
        "Fly ball"
      when event_description.match(/sacrifice fly/)
        "Fly ball"
      when event_description.match(/flies into a/)
        "Fly ball"
      when event_description.match(/ground(s)?( (ball|into|out)|, fielded)/)
        "Ground ball"
      when event_description.match(/fielder's choice/)
        "Ground ball"
      when event_description.match(/((hits|out on) a sacrifice|ground) bunt/)
        "Ground ball"
      when event_description.match(/reaches on a(n)? ((fielding |missed catch |throwing )?error|force attempt)/)
        "Ground ball"
      when event_description.match(/pop(s)? (into a(n)? (unassisted )?double play|(into a force )?out|up)/)
        "Pop up"
      when event_description.match(/(grand slam|home run)/)
        "Fly ball"
      when event_description.match(/(\AThrowing error|catcher interference|caught stealing|fan interference|hit by pitch|strikes out|out on strikes|walks)/)
        nil
      when event_description.match(/(passed ball|wild pitch).+out at/) then nil
      when event_description.match(/picks off/) then nil
      when event_description.match(/\A(\w+ challenged ([A-Za-z]|\s|\(|\)|\-|\,)+\:)?([A-Za-z]|\s)+(, Jr.)? out at /)
        nil
      when event_description.match(/ triples\.\s+\Z/) then nil
      when event_description.match(/ doubles\.\s+\Z/) then nil
      when event_description.match(/ singles\.\s+\Z/) then nil
      else
        raise "No match for batted ball type on '#{event_description}'"
        nil
      end
    end

    protected

    attr_reader :event_description
  end
end
