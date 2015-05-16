module Moneyball
  class BattedBallLocationExtractor
    def initialize(event_description)
      @event_description = event_description
    end

    def classification
      case
      when event_description.match(deflected_by_regex("first baseman")) then "1B"
      when event_description.match(deflected_by_regex("second baseman")) then "2B"
      when event_description.match(deflected_by_regex("third baseman")) then "3B"
      when event_description.match(deflected_by_regex("shortstop")) then "SS"
      when event_description.match(unassisted_regex("first baseman")) then "1B"
      when event_description.match(unassisted_regex("second baseman")) then "2B"
      when event_description.match(unassisted_regex("third baseman")) then "3B"
      when event_description.match(unassisted_regex("shortstop")) then "SS"
      when event_description.match(infielder_regex("catcher")) then "C"
      when event_description.match(infielder_regex("first baseman")) then "1B"
      when event_description.match(infielder_regex("second baseman")) then "2B"
      when event_description.match(infielder_regex("third baseman")) then "3B"
      when event_description.match(infielder_regex("shortstop")) then "SS"
      when event_description.match(infielder_regex("pitcher")) then "P"
      when event_description.match(outfielder_regex("left")) then "LF"
      when event_description.match(outfielder_regex("center")) then "CF"
      when event_description.match(outfielder_regex("right")) then "RF"
      when event_description.match(flies_into_sacrifice_double_play_regex("left"))
        "LF"
      when event_description.match(flies_into_sacrifice_double_play_regex("center"))
        "CF"
      when event_description.match(flies_into_sacrifice_double_play_regex("right"))
        "RF"
      when event_description.match(/(caught stealing|fan interference|hit by pitch|reaches on catcher interference|strikes out|out on strikes|walks)/)
        nil
      when event_description.match(/(passed ball|wild pitch).+out at/) then nil
      when event_description.match(/picks off/) then nil
      when event_description.match(/\AThrowing error by/) then nil
      when event_description.match(/\A(\w+ challenged([A-Za-z\s\(\)\-\,])+\:)?([A-Za-z]|\s)+(, Jr.)? out at /)
        nil
      when event_description.match(/ (doubles|hits a home run|singles|triples)\.\s+\Z/) then nil
      else
        raise "No match for batted ball location on '#{event_description}'"
        nil
      end
    end

    protected

    attr_reader :event_description

    private

    def deflected_by_regex(position)
      /deflected by #{position}/
    end

    def infielder_regex(position)
      /(ball to|bunt(,| to)|fielded by|(F|f)ielding error by|fly to|line drive to|reaches on a (force attempt, )?missed catch error by [A-Za-z\s\.]+, assist to|out( sharply| softly)? ?(,| to)|play,|pop up to|reaches on a(n)? (fielding |throwing )?error by|reaches on a force attempt, throwing error by|bunt\.\s+Throwing error by|pops into a double play in foul territory,) ?#{position}/
    end

    def outfielder_regex(position)
      /((ground|fly) ball|drive|fielding error|flies into a double play|fly|grand slam( \(\d?\))|lines into a double play|out)( sharply| softly)?(,| by| down the| to) #{position}(-field line)?/
    end

    def flies_into_sacrifice_double_play_regex(position)
      /flies into a sacrifice double play(,| to) #{position} fielder/
    end

    def unassisted_regex(position)
      /#{position}[A-Za-z\s]+unassisted/
    end
  end
end
