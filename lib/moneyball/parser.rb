module Moneyball
  class Parser
    def initialize(node)
      @node = node
    end

    def stats
      {
        pa: pa,
        ab: ab,
        h: h,
        h_1b: h_1b,
        h_2b: h_2b,
        h_3b: h_3b,
        hr: hr,
        bb: bb,
        ibb: ibb,
        k: k,
        roe: roe,
        gidp: gidp,
        dp: dp,
        tp: tp,
        hbp: hbp,
        sf: sf,
        sh: sh,
        fc: fc,
        bi: bi,
        ci: ci,
        fi: fi,
        r: r,
        rbi: rbi
      }
    end

    protected

    attr_reader :node

    private

    def batter_id
      @batter_id ||= node.attribute("batter").value
    end

    def r
      @r = node.search("runner[id='#{batter_id}'][score='T']").any? ? 1 : 0
    end

    def rbi
      @r = node.search("runner[rbi='T']").count
    end

    def event_value
      @event_value ||= node.attribute("event").value
    end

    def event_matches(regex)
      if event_value.match(regex)
        1
      else
        0
      end
    end

    def any_outcomes_occurred(outcomes)
      if outcomes.any? { |outcome| outcome == 1 }
        1
      else
        0
      end
    end

    def ab
      @ab ||= any_outcomes_occurred([
        h,
        k,
        batted_out,
        double_play,
        tp,
        roe,
        force_out,
        fc,
        bi,
        fi
      ])
    end

    def bi
      @bi ||= event_matches(/Batter Interference/)
    end

    def bb
      @bb ||= event_matches(/Walk/)
    end

    def ibb
      @ibb ||= event_matches(/(I|i)ntent(ional)? (W|w)alk/)
    end

    def ci
      @ci ||= event_matches(/Catcher Interference/)
    end

    def gidp
      @gidp ||= event_matches(/((G|g)rounded (I|i)nto|Sacrifice Bunt) DP/)
    end

    def dp
      @dp ||= any_outcomes_occurred([gidp, double_play, sacrifice_double_play])
    end

    def tp
      @tp ||= event_matches(/(T|t)riple (P|p)lay/)
    end

    def sacrifice_double_play
      @sacrifice_double_play ||= event_matches(/Sac (Bunt|Fly) DP/)
    end

    def double_play
      @double_play ||= event_matches(/((D|d)ouble (P|p)lay| - DP)/)
    end

    def fc
      @fc ||= event_matches(/Fielders Choice( Out)?/)
    end

    def fi
      @fi ||= event_matches(/Fan (I|i)nterference/)

      if @fi
        parse_hit_from_description
      end

      @fi
    end

    def h
      @h ||= any_outcomes_occurred([h_1b, h_2b, h_3b, hr])
    end

    def hbp
      @hbp ||= event_matches(/Hit By Pitch/)
    end

    def h_1b
      @h_1b ||= event_matches(/(S|s)ingle/)
    end

    def h_2b
      @h_2b ||= event_matches(/(D|d)ouble\Z/)
    end

    def h_3b
      @h_3b ||= event_matches(/(T|t)riple?\Z/)
    end

    def hr
      @hr ||= event_matches(/(H|h)ome (R|r)un/)
    end

    def k
      @k ||= event_matches(/(S|s)trikeout/)
    end

    def batted_out
      @batter_out ||= event_matches(/(Fly|Ground|Line|Pop)( )?(O|o)ut|Grounded Into DP/)
    end

    def force_out
      @force_out ||= event_matches(/Forceout/)
    end

    def pa
      @pa ||= if !event_value.match(/Runner Out/)
        1
      else
        0
      end
    end

    def roe
      @reached_on_error ||= event_matches(/Field Error/)
    end

    def sf
      @sf ||= event_matches(/Sac Fly/)
    end

    def sh
      @sh ||= event_matches(/Sac(rifice)? Bunt/)
    end

    def parse_hit_from_description
      description = node.attribute("des").value

      if description.match(/singles/)
        @h = 1
        @h_1b = 1
      elsif description.match(/doubles/)
        @h = 1
        @h_2b = 1
      elsif description.match(/ground-rule double/)
        @h = 1
        @h_2b = 1
      elsif description.match(/triples/)
        @h = 1
        @h_3b = 1
      elsif description.match(/hits a sacrifice bunt/) && description.match(/error/)
        @roe = 1
      end
    end
  end
end
