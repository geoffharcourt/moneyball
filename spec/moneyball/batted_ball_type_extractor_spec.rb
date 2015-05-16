require "spec_helper"

describe Moneyball::BattedBallTypeExtractor do
  describe "#classification" do
    it "returns nil for a hit by pitch" do
      extractor = described_class.new("Andrelton Simmons hit by pitch. ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a walk" do
      extractor = described_class.new("Phil Gosselin walks.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a swinging strikeout" do
      extractor = described_class.new("Bryce Harper strikes out swinging. ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a called strikeout" do
      extractor = described_class.new("Jonny Gomes called out on strikes. ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil for a caught stealing" do
      extractor = described_class.new("With Ian Kinsler batting, Anthony Gose caught stealing 2nd base, catcher Salvador Perez to second baseman Omar Infante.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat ends the inning with a runner out at home via a rundown" do
      extractor = described_class.new("With Evan Gattis batting, wild pitch by Roenis Elias, .  Jose Altuve out at home, catcher Jesus Sucre to second baseman Robinson Cano to third baseman Kyle Seager.  ")

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

    it "returns nil when the at bat ends the inning with a runner picked off" do
      extractor = described_class.new("With Austin Green batting, Brian Ward picks off Josh Wilson at 1st on throw to Chris Parmelee.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the inning ends with a throwing error on a pickoff followed by a runner thrown out" do
      extractor = described_class.new("Throwing error by pitcher Adam Wilk on the pickoff attempt.  Bryan Petersen out at 3rd, second baseman Johnny Giavotella to third baseman Kyle Kubitza.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil on catcher inteference" do
      extractor = described_class.new("Tommy La Stella reaches on catcher interference by Tommy Murphy.    Tommy La Stella to 1st.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat is simply described as '[Player X] triples.'" do
      extractor = described_class.new("Alexi Casilla triples.  ")

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

    it "returns nil when the at bat ends with a pickoff" do
      extractor = described_class.new("With Ian Kinsler batting, A.  J.   Burnett picks off Rajai Davis at 1st on throw to Pedro Alvarez.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns nil when the at bat has fan interference and no field is specified" do
      extractor = described_class.new("Umpire reviewed (fan interference), call on the field was overturned: Carlos Santana doubles (1).   Michael Bourn scores.  ")

      expect(extractor.classification).to be_nil
    end

    it "returns 'Line drive' for a line drive hit" do
      extractor = described_class.new("Freddie Freeman doubles (12) on a line drive to center fielder Denard Span.   Andrelton Simmons to 3rd.  ")

      expect(extractor.classification).to eq("Line drive")
    end

    it "returns 'Line drive' for a lineout" do
      extractor = described_class.new("'Yunel Escobar lines out to center fielder Cameron Maybin.  ")

      expect(extractor.classification).to eq("Line drive")
    end

    it "returns 'Line drive' for a lineout into a double play" do
      extractor = described_class.new("Cameron Maybin lines into an unassisted double play, first baseman Ryan Zimmerman.   Phil Gosselin doubled off 1st.  ")

      expect(extractor.classification).to eq("Line drive")
    end

    it "returns 'Fly ball' for a flyball homerun" do
      extractor = described_class.new("Jayson Werth homers (1) on a fly ball to left field. ")

      expect(extractor.classification).to eq("Fly ball")
    end

    it "returns 'Fly ball' for a flyout" do
      extractor = described_class.new("Wilson Ramos flies out to left fielder Jonny Gomes. ")

      expect(extractor.classification).to eq("Fly ball")
    end

    it "returns 'Fly ball' for a sacrifice fly" do
      extractor = described_class.new("Jonny Gomes out on a sacrifice fly to center fielder Denard Span.   Andrelton Simmons scores.  ")

      expect(extractor.classification).to eq("Fly ball")
    end

    it "returns 'Fly ball' for a sacrifice fly double play" do
      extractor = described_class.new("Kevin Pillar flies into a sacrifice double play, right fielder Daniel Nava to first baseman Travis Shaw to shortstop Xander Bogaerts.   Russell Martin scores.    Danny Valencia out at 2nd on the throw.  ")

      expect(extractor.classification).to eq("Fly ball")
    end

    it "returns 'Fly ball' for a flyball double play" do
      extractor = described_class.new("Tigers challenged (touching a base), call on the field was upheld: Ian Kinsler flies into a double play, center fielder Lorenzo Cain to second baseman Omar Infante.   Anthony Gose out at 2nd.  ")

      expect(extractor.classification).to eq("Fly ball")
    end

    it "returns 'Fly ball' for a grand slam without a specific batted ball type" do
      extractor = described_class.new("Casey McGehee hits a grand slam (2) to center field.   Buster Posey scores.    Brandon Belt scores.    Justin Maxwell scores.  ")

      expect(extractor.classification).to eq("Fly ball")
    end

    it "returns 'Ground ball' for a groundout" do
      extractor = described_class.new("Nick Markakis grounds out, second baseman Danny Espinosa to first baseman Ryan Zimmerman.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a groundball hit" do
      extractor = described_class.new("Ryan Zimmerman singles on a ground ball to right fielder Nick Markakis.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a sacrifice bunt" do
      extractor = described_class.new("Tim Lincecum out on a sacrifice bunt, pitcher Jarred Cosart to first baseman Michael Morse.   Casey McGehee to 2nd.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for an out on a bunt hit" do
      extractor = described_class.new("Sam Fuld ground bunts into a force out, pitcher Taijuan Walker to third baseman Kyle Seager.   Eric Sogard out at 3rd.    Coco Crisp to 2nd.    Sam Fuld to 1st.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a sacrifice bunt with a fielding error" do
      extractor = described_class.new("Jordan Schafer hits a sacrifice bunt.    Fielding error by first baseman Carlos Santana.   Kurt Suzuki scores.    Kennys Vargas to 2nd.    Jordan Schafer to 1st.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a GIDP" do
      extractor = described_class.new("Andrelton Simmons grounds into a double play, shortstop Ian Desmond to second baseman Danny Espinosa to first baseman Ryan Zimmerman.   Nick Markakis out at 2nd.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a fielder's choice out" do
      extractor = described_class.new("Russell Martin reaches on a fielder's choice out, pitcher Wade Miley to third baseman Pablo Sandoval to catcher Blake Swihart.   Jose Bautista out at home.    Edwin Encarnacion to 3rd.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a fielder's choice" do
      extractor = described_class.new("Alexi Amarista reaches on a fielder's choice, fielded by second baseman Aaron Hill.   Will Venable scores.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a fielder's choice double play" do
      extractor = described_class.new("Rickie Weeks hit into a fielder's choice double play, third baseman Rafael Ynoa to first baseman Wilin Rosario.   Jordy Lara out at home.    Rickie Weeks out at 1st.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for reaching on a force attempt" do
      extractor = described_class.new("Wil Myers reaches on a force attempt, fielding error by third baseman Nolan Arenado.   Will Middlebrooks scores.    Alexi Amarista scores.    Cory Spangenberg to 3rd.    Wil Myers to 2nd.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a reaching on a fielding error" do
      extractor = described_class.new("Blue Jays challenged (play at 1st), call on the field was upheld: Xander Bogaerts reaches on a fielding error by third baseman Josh Donaldson.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a reaching on a throwing error" do
      extractor = described_class.new("Jose Altuve reaches on a throwing error by shortstop Erick Aybar.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Ground ball' for a reaching on a missed catch error" do
      extractor = described_class.new("Kolten Wong reaches on a missed catch error by pitcher A.  J.   Burnett, assist to first baseman Pedro Alvarez.  ")

      expect(extractor.classification).to eq("Ground ball")
    end

    it "returns 'Pop up' for a popup to shortstop" do
      extractor = described_class.new("Jayson Werth pops out to shortstop Andrelton Simmons.  ")

      expect(extractor.classification).to eq("Pop up")
    end

    it "returns 'Pop up' for a pop fly double play" do
      extractor = described_class.new("Dalton Pompey pops into an unassisted double play, catcher Humberto Quintero.   Edwin Encarnacion out at home.  ")

      expect(extractor.classification).to eq("Pop up")
    end

    it "returns 'Pop up' for a pop-up force out (???)" do
      extractor = described_class.new("Mike Moustakas pops into a force out, third baseman Gordon Beckham to second baseman Carlos Sanchez.   Alcides Escobar out at 2nd.    Mike Moustakas to 1st.  ")

      expect(extractor.classification).to eq("Pop up")
    end
  end
end
