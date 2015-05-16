require "spec_helper"

RSpec.describe Moneyball::BattedBallLocationExtractor do
  describe "#classification" do
    it "returns 'P' groundout and throwing error by the pitcher" do
      extractor = described_class.new("Chris Herrmann reaches on a force attempt, throwing error by pitcher John Danks.   Oswaldo Arcia to 3rd.    Shane Robinson to 2nd.  ")

      expect(extractor.classification).to eq("P")
    end

    it "returns 'P' for a sharp groundout to the pitcher" do
      extractor = described_class.new("Travis Snider grounds out sharply, pitcher Justin Wilson to first baseman Mark Teixeira.  ")

      expect(extractor.classification).to eq("P")
    end

    it "returns 'P' for a bunt to the pitcher" do
      extractor = described_class.new("Tim Lincecum out on a sacrifice bunt, pitcher Jarred Cosart to first baseman Michael Morse.   Casey McGehee to 2nd.  ")

      expect(extractor.classification).to eq("P")
    end

    it "returns 'P' for a bunt to the pitcher and a throwing error" do
      extractor = described_class.new("Mat Latos hits a sacrifice bunt.   Throwing error by pitcher Stephen Strasburg.   Ichiro Suzuki scores.    Adeiny Hechavarria to 2nd.    Mat Latos to 1st.  ")

      expect(extractor.classification).to eq("P")
    end

    it "returns 'C' for a soft groundout to catcher" do
      extractor = described_class.new("Jimmy Paredes grounds out softly, catcher Brian McCann to first baseman Mark Teixeira.   Manny Machado to 2nd.  ")

      expect(extractor.classification).to eq("C")
    end

    it "returns '1B' for a lineout into a double play started by the first baseman" do
      extractor = described_class.new("Cameron Maybin lines into an unassisted double play, first baseman Ryan Zimmerman.   Phil Gosselin doubled off 1st.  ")

      expect(extractor.classification).to eq("1B")
    end

    it "returns '1B' for a groundout to first base" do
      extractor = described_class.new("Eric Stults grounds out to first baseman Ryan Zimmerman.  ")

      expect(extractor.classification).to eq("1B")
    end

    it "returns '1B' for a sharp lineout hit deflected by the first baseman" do
      extractor = described_class.new("Brandon Belt singles on a sharp line drive to second baseman Donovan Solano, deflected by first baseman Michael Morse.   Buster Posey to 2nd.  ")

      expect(extractor.classification).to eq("1B")
    end

    it "returns '1B' for a bunt with a fielding error by the first baseman" do
      extractor = described_class.new("Jordan Schafer hits a sacrifice bunt.    Fielding error by first baseman Carlos Santana.   Kurt Suzuki scores.    Kennys Vargas to 2nd.    Jordan Schafer to 1st.  ")

      expect(extractor.classification).to eq("1B")
    end

    it "returns '1B' for a ground ball to first with a missed catch by another fielder covering" do
      extractor = described_class.new("Conor Gillaspie reaches on a force attempt, missed catch error by shortstop Danny Santana, assist to first baseman Kennys Vargas.    Jose Abreu to 3rd.  ")

      expect(extractor.classification).to eq("1B")
    end

    it "returns '1B' for a fly ball double play beginning in foul territory by first base" do
      extractor = described_class.new("David Ross pops into a double play in foul territory, first baseman Paul Goldschmidt to catcher Tuffy Gosewisch.   Arismendy Alcantara out at home.  ")

      expect(extractor.classification).to eq("1B")
    end

    it "returns '2B' for a groundout to second base" do
      extractor = described_class.new("Nick Markakis grounds out, second baseman Danny Espinosa to first baseman Ryan Zimmerman.  ")

      expect(extractor.classification).to eq("2B")
    end

    it "returns '2B' for a sharp lineout to second base" do
      extractor = described_class.new("Phil Gosselin lines out sharply to second baseman Danny Espinosa.  ")

      expect(extractor.classification).to eq("2B")
    end

    it "returns '2B' for a pop up hit to second base" do
      extractor = described_class.new("Justin Maxwell singles on a pop up to second baseman Johnny Giavotella.  ")

      expect(extractor.classification).to eq("2B")
    end

    it "returns '2B' for an unassisted play by the second baseman" do
      extractor = described_class.new("Matt Joyce singles on a ground ball.  Taylor Featherston out at 2nd, hit by batted ball, second baseman Joe Panik unassisted.  ")

      expect(extractor.classification).to eq("2B")
    end

    it "returns '3B' for a groundball single to third base" do
      extractor = described_class.new("Jonny Gomes singles on a ground ball to third baseman Yunel Escobar.   Freddie Freeman to 3rd.  ")

      expect(extractor.classification).to eq("3B")
    end

    it "returns '3B' for a line drive single to third base" do
      extractor = described_class.new("Chris Herrmann singles on a line drive to third baseman Gordon Beckham.   Kennys Vargas scores.    Jordan Schafer to 2nd.  ")

      expect(extractor.classification).to eq("3B")
    end

    it "returns '3B' for a groundout to third base" do
      extractor = described_class.new("Gio Gonzalez grounds out, third baseman Alberto Callaspo to first baseman Freddie Freeman.  ")

      expect(extractor.classification).to eq("3B")
    end

    it "returns '3B' for a reaches on error by the third baseman" do
      extractor = described_class.new("Blue Jays challenged (play at 1st), call on the field was upheld: Xander Bogaerts reaches on a fielding error by third baseman Josh Donaldson.  ")

      expect(extractor.classification).to eq("3B")
    end

    it "returns 'SS' for a groundout to shortstop" do
      extractor = described_class.new("Jayson Werth pops out to shortstop Andrelton Simmons.  ")

      expect(extractor.classification).to eq("SS")
    end

    it "returns 'SS' for a groundout fielded by the shortstop (fielder's choice)" do
      extractor = described_class.new("Anthony Rizzo grounds into a force out, fielded by shortstop Jean Segura.   Kris Bryant out at 2nd.  ")

      expect(extractor.classification).to eq("SS")
    end

    it "returns 'SS' for a groundball with a throwing error by the shortstop" do
      extractor = described_class.new("Jose Altuve reaches on a throwing error by shortstop Erick Aybar.  ")

      expect(extractor.classification).to eq("SS")
    end

    it "returns 'LF' for a homer to left field" do
      extractor = described_class.new("Jayson Werth homers (1) on a fly ball to left field.  ")

      expect(extractor.classification).to eq("LF")
    end

    it "returns 'LF' for a sharp lineout to left field" do
      extractor = described_class.new("Jimmy Paredes lines out sharply to left fielder Brett Gardner.  ")

      expect(extractor.classification).to eq("LF")
    end

    it "returns 'CF' for a line drive to center field" do
      extractor = described_class.new("Freddie Freeman doubles (12) on a line drive to center fielder Denard Span.   Andrelton Simmons to 3rd.  ")

      expect(extractor.classification).to eq("CF")
    end

    it "returns 'CF' for a sacrifice fly to center field" do
      extractor = described_class.new("Jonny Gomes out on a sacrifice fly to center fielder Denard Span.   Andrelton Simmons scores.  ")

      expect(extractor.classification).to eq("CF")
    end

    it "returns 'CF' for a line out to center field" do
      extractor = described_class.new("Yunel Escobar lines out to center fielder Cameron Maybin.  ")

      expect(extractor.classification).to eq("CF")
    end

    it "returns 'CF' for a flyout double play to center field" do
      extractor = described_class.new("Tigers challenged (touching a base), call on the field was upheld: Ian Kinsler flies into a double play, center fielder Lorenzo Cain to second baseman Omar Infante.   Anthony Gose out at 2nd.  ")

      expect(extractor.classification).to eq("CF")
    end

    it "returns 'CF' for a grand slam" do
      extractor = described_class.new("Casey McGehee hits a grand slam (2) to center field.   Buster Posey scores.    Brandon Belt scores.    Justin Maxwell scores.  ")

      expect(extractor.classification).to eq("CF")
    end

    it "returns 'RF' for a line drive down the right field line" do
      extractor = described_class.new("Lonnie Chisenhall hits a ground-rule double (4) on a line drive down the right-field line.  ")

      expect(extractor.classification).to eq("RF")
    end

    it "returns 'RF' for a fly out to right field" do
      extractor = described_class.new("Alberto Callaspo flies out to right fielder Bryce Harper in foul territory.  ")

      expect(extractor.classification).to eq("RF")
    end

    it "returns 'RF' for a sacrifice fly double play" do
      extractor = described_class.new("Kevin Pillar flies into a sacrifice double play, right fielder Daniel Nava to first baseman Travis Shaw to shortstop Xander Bogaerts.   Russell Martin scores.    Danny Valencia out at 2nd on the throw.  ")

      expect(extractor.classification).to eq("RF")
    end

    it "returns 'RF' for a groundball hit to right field" do
      extractor = described_class.new("Ryan Zimmerman singles on a ground ball to right fielder Nick Markakis.  ")

      expect(extractor.classification).to eq("RF")
    end

    it "returns 'RF' for a lineout double play to right field" do
      extractor = described_class.new("'Dustin Ackley lines into a double play, right fielder Josh Reddick to first baseman Ike Davis.   Logan Morrison doubled off 1st.  ")

      expect(extractor.classification).to eq("RF")
    end

    it "returns 'RF' for a fielding error by the right fielder" do
      extractor = described_class.new("Chris Coghlan reaches on a fielding error by right fielder Ryan Braun.   Chris Coghlan to 2nd.  ")

      expect(extractor.classification).to eq("RF")
    end

    it "returns nil for a caught stealing" do
      extractor = described_class.new("With Ian Kinsler batting, Anthony Gose caught stealing 2nd base, catcher Salvador Perez to second baseman Omar Infante.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a hit by pitch" do
      extractor = described_class.new("Andrelton Simmons hit by pitch. ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a walk" do
      extractor = described_class.new("Phil Gosselin walks.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a strikeout swinging" do
      extractor = described_class.new("Bryce Harper strikes out swinging.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a called strikeout" do
      extractor = described_class.new("Jonny Gomes called out on strikes.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil on catcher inteference" do
      extractor = described_class.new("Tommy La Stella reaches on catcher interference by Tommy Murphy.    Tommy La Stella to 1st.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat ends the inning with a runner picked off" do
      extractor = described_class.new("With Austin Green batting, Brian Ward picks off Josh Wilson at 1st on throw to Chris Parmelee.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the inning ends with a throwing error on a pickoff followed by a runner thrown out" do
      extractor = described_class.new("Throwing error by pitcher Adam Wilk on the pickoff attempt.  Bryan Petersen out at 3rd, second baseman Johnny Giavotella to third baseman Kyle Kubitza.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat ends the inning with a runner out at home running on a wild pitch or passed ball" do
      extractor = described_class.new("Adrian Gonzalez out at home, catcher Nick Hundley to pitcher Eddie Butler.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat ends the inning with a runner out at home running on a wild pitch or passed ball and a manager challenge" do
      extractor = described_class.new("Phillies challenged (home-plate collision), call on the field was upheld: Ryan Howard out at home, catcher J.  T.   Realmuto to pitcher Tom Koehler.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat ends the inning with a runner out at home via a rundown" do
      extractor = described_class.new("With Evan Gattis batting, wild pitch by Roenis Elias, .  Jose Altuve out at home, catcher Jesus Sucre to second baseman Robinson Cano to third baseman Kyle Seager.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat has fan interference and no field is specified" do
      extractor = described_class.new("Umpire reviewed (fan interference), call on the field was overturned: Carlos Santana doubles (1).   Michael Bourn scores.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat is simply described as '[Player X] triples.'" do
      extractor = described_class.new("Alexi Casilla triples.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat is simply described as '[Player X] hits a home run.'" do
      extractor = described_class.new("Brett Eibner hits a home run.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat is simply described as '[Player X] doubles.'" do
      extractor = described_class.new("Alexi Casilla doubles.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat is simply described as '[Player X] singles.'" do
      extractor = described_class.new("Alexi Casilla singles.  ")

      expect(extractor.classification).to be_nil
    end
  end
end
