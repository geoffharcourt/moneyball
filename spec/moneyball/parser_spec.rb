require "spec_helper"

RSpec.describe Moneyball::Parser do
  describe "#stats" do
    describe "on a single" do
      it "records a plate appearance, at-bat, hit, and single" do
        node = Nokogiri::XML(%q{
          <atbat num="2" b="1" s="0" o="1" start_tfs="200732" start_tfs_zulu="2015-04-18T20:07:32Z" batter="456665" stand="R" b_height="5-11" pitcher="453329" p_throws="R" des="Steve Pearce singles on a line drive to left fielder Hanley Ramirez. " des_es="Steve Pearce pega sencillo con línea a jardinero izquierdo Hanley Ramirez. " event_num="11" event="Single" event_es="Sencillo" play_guid="d8fb55e8-0955-4ae2-baa5-55fa9d511bcd" home_team_runs="0" away_team_runs="0"> </atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(1)
        expect(parser.stats[:h_1b]).to eq(1)
      end
    end

    describe "on a double" do
      it "records a plate appearance, at-bat, hit, and double" do
        node = Nokogiri::XML(%q{
          <atbat num="25" b="3" s="2" o="0" start_tfs="210247" start_tfs_zulu="2015-04-18T21:02:47Z" batter="517370" stand="L" b_height="6-3" pitcher="453329" p_throws="R" des="Jimmy Paredes doubles (1) on a fly ball to left fielder Hanley Ramirez. Adam Jones to 3rd. " des_es="Jimmy Paredes pega doble (1) con elevado a jardinero izquierdo Hanley Ramirez. Adam Jones a 3ra. " event_num="195" event="Double" event_es="Doble" home_team_runs="0" away_team_runs="0"> </atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(1)
        expect(parser.stats[:h_2b]).to eq(1)
        expect(parser.stats[:dp]).to eq(0)
        expect(parser.stats[:gidp]).to eq(0)
      end
    end

    describe "on a triple" do
      it "records a plate appearance, at-bat, hit, and triple" do
        node = Nokogiri::XML(%q{
          <atbat num="52" b="0" s="1" o="0" start_tfs="185749" start_tfs_zulu="2015-05-09T18:57:49Z" batter="517370" stand="L" b_height="6-3" pitcher="502304" p_throws="R" des="Jimmy Paredes triples (2) on a line drive to right fielder Chris Young. " des_es="Jimmy Paredes pega triple (2) con línea al jardinero derecho Chris Young. " event_num="393" event="Triple" event_es="Triple" play_guid="be9b5cc4-5963-4f39-8847-a0375649626d" home_team_runs="1" away_team_runs="5"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(1)
        expect(parser.stats[:h_3b]).to eq(1)
        expect(parser.stats[:tp]).to eq(0)
      end
    end

    describe "on a home run" do
      it "records a plate appearance, at-bat, hit, home run, run, and the correct number of RBI" do
        node = Nokogiri::XML(%q{
          <atbat num="28" b="2" s="2" o="2" start_tfs="180604" start_tfs_zulu="2015-05-09T18:06:04Z" batter="457477" stand="L" b_height="6-0" pitcher="595032" p_throws="R" des="Alejandro De Aza homers (3) on a line drive to right field. Steve Pearce scores. " des_es="Alejandro De Aza batea jonrón (3) con línea por el jardín derecho. Steve Pearce anota. " event_num="221" event="Home Run" event_es="Jonrón" score="T" home_team_runs="0" away_team_runs="4">
            <runner id="456665" start="1B" end="" event="Pickoff Attempt 1B" event_num="221" score="T" rbi="T" earned="T"/>
            <runner id="457477" start="" end="" event="Pickoff Attempt 1B" event_num="221" score="T" rbi="T" earned="T"/>
          </atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(1)
        expect(parser.stats[:hr]).to eq(1)
        expect(parser.stats[:r]).to eq(1)
        expect(parser.stats[:rbi]).to eq(2)
      end
    end

    describe "on a walk" do
      it "records a plate appearance, walk, and no at-bat or hit" do
        node = Nokogiri::XML(%q{
          <atbat num="46" b="4" s="1" o="2" start_tfs="184117" start_tfs_zulu="2015-05-09T18:41:17Z" batter="543432" stand="R" b_height="6-4" pitcher="595032" p_throws="R" des="Ryan Lavarnway walks. " des_es="Ryan Lavarnway recibe base por bolas. " event_num="344" event="Walk" event_es="Base por Bolas" play_guid="e520cd68-93be-41a0-9491-c6a1d33406f5" home_team_runs="1" away_team_runs="5"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:bb]).to eq(1)
        expect(parser.stats[:ibb]).to eq(0)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on an intentional walk" do
      it "records a plate appearance, walk, intentional walk and no at-bat or hit" do
        node = Nokogiri::XML(%q{
          <atbat num="79" b="4" s="0" o="0" start_tfs="231345" start_tfs_zulu="2015-03-07T23:13:45Z" batter="519107" stand="R" b_height="6-0" pitcher="500891" p_throws="L" des="Edgar Ibarra intentionally walks Andy Parrino. Eric Sogard to 2nd. " des_es="Edgar Ibarra recibe base por bolas intencional Andy Parrino. Eric Sogard a 2da. " event_num="537" event="Intent Walk" event_es="Base por Bolas Intencional" home_team_runs="7" away_team_runs="7"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:bb]).to eq(1)
        expect(parser.stats[:ibb]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a strikeout" do
      it "records a plate appearance, at-bat, strikeout, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="53" b="0" s="3" o="1" start_tfs="185927" start_tfs_zulu="2015-05-09T18:59:27Z" batter="430945" stand="R" b_height="6-2" pitcher="502304" p_throws="R" des="Adam Jones strikes out swinging. " des_es="Adam Jones se poncha tirándole. " event_num="399" event="Strikeout" event_es="Ponche" play_guid="ee74c5e8-8fcc-40f9-b0b2-fd6c81980aad" home_team_runs="1" away_team_runs="5"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:k]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a strikeout - double play" do
      it "records a plate appearance, at-bat, strikeout, double play, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="2" b="0" s="3" o="2" start_tfs="180900" start_tfs_zulu="2015-03-03T18:09:00Z" batter="570731" stand="R" b_height="6-2" pitcher="543456" p_throws="L" des="Jonathan Schoop strikes out swinging and Everth Cabrera caught stealing 2nd, catcher Alex Avila to second baseman Ian Kinsler. " des_es="Jonathan Schoop se poncha tirándole y Everth Cabrera atrapado robando la 2da, receptor Alex Avila a segunda base Ian Kinsler. " event_num="12" event="Strikeout - DP" event_es="Doble Play en Ponche" event2="Caught Stealing 2B" event2_es="Retirado en Intento de Robo 2B" home_team_runs="0" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:k]).to eq(1)
        expect(parser.stats[:dp]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a popout" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="56" b="0" s="1" o="3" start_tfs="190505" start_tfs_zulu="2015-05-09T19:05:05Z" batter="456665" stand="R" b_height="5-11" pitcher="502304" p_throws="R" des="Steve Pearce pops out to second baseman Jose Pirela. " des_es="Steve Pearce batea elevadito de out a segunda base Jose Pirela. " event_num="421" event="Pop Out" event_es="Elevado de Out" play_guid="4b4384cc-eb64-4f27-aa76-990164f19f45" home_team_runs="1" away_team_runs="6"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a groundout" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="61" b="2" s="2" o="1" start_tfs="191906" start_tfs_zulu="2015-05-09T19:19:06Z" batter="429666" stand="R" b_height="6-1" pitcher="592741" p_throws="L" des="J. Hardy grounds out, shortstop Stephen Drew to first baseman Mark Teixeira. " des_es="J. Hardy batea rodado de out, campo corto Stephen Drew a primera base Mark Teixeira. " event_num="465" event="Groundout" event_es="Roletazo de Out" play_guid="f66c450a-51f4-44a8-8be2-133b9368ef2b" home_team_runs="1" away_team_runs="6"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a lineout" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="56" b="0" s="1" o="1" start_tfs="195246" start_tfs_zulu="2015-03-02T19:52:46Z" batter="594983" stand="L" b_height="6-3" pitcher="661835" p_throws="R" des="Viosergy Rosa lines out to left fielder Jack Schaaf. " des_es="Viosergy Rosa batea línea de out a jardinero izquierdo Jack Schaaf. " event_num="363" event="Lineout" event_es="Línea de Out" home_team_runs="6" away_team_runs="2"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a groundout forceout (a runner other than the batter thrown out)" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="19" b="0" s="1" o="2" start_tfs="184709" start_tfs_zulu="2015-03-01T18:47:09Z" batter="661447" stand="L" b_height="5-10" pitcher="501989" p_throws="L" des="Casey Scoggins grounds into a force out, second baseman Cesar Hernandez to shortstop Chase d'Arnaud. Chris Pagliarulo out at 2nd. Casey Scoggins to 1st. " des_es="Casey Scoggins batea rodado batea para out forzado, segunda base Cesar Hernandez a campo corto Chase d'Arnaud. Chris Pagliarulo a cabo a 2da. Casey Scoggins a 1ra. " event_num="115" event="Forceout" event_es="Out Forzado" home_team_runs="2" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a flyout" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="69" b="1" s="1" o="3" start_tfs="193803" start_tfs_zulu="2015-05-09T19:38:03Z" batter="517369" stand="R" b_height="5-11" pitcher="488984" p_throws="R" des="Jose Pirela flies out to center fielder Adam Jones. " des_es="Jose Pirela batea elevado de out a jardinero central Adam Jones. " event_num="530" event="Flyout" event_es="Elevado de Out" play_guid="cb4d7ec2-d339-4689-98bc-dc925dc07ff4" home_team_runs="2" away_team_runs="6"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a GIDP" do
      it "records a plate appearance, at-bat, double-play, GIDP, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="72" b="1" s="0" o="3" start_tfs="194349" start_tfs_zulu="2015-05-09T19:43:49Z" batter="430945" stand="R" b_height="6-2" pitcher="592741" p_throws="L" des="Adam Jones grounds into a double play, third baseman Chase Headley to second baseman Jose Pirela to first baseman Mark Teixeira. Jimmy Paredes out at 2nd. " des_es="Adam Jones batea rodado batea para doble matanza, tercera base Chase Headley a segunda base Jose Pirela a primera base Mark Teixeira. Jimmy Paredes a cabo a 2da. " event_num="550" event="Grounded Into DP" event_es="Roletazo de Doble Play" play_guid="94068200-f891-4c20-b08e-1b18f9a69de6" home_team_runs="2" away_team_runs="6"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:gidp]).to eq(1)
        expect(parser.stats[:dp]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a lineout double play" do
      it "records a plate appearance, at-bat, double-play, but no GIDP or hit" do
        node = Nokogiri::XML(%q{
          <atbat num="62" b="1" s="1" o="2" start_tfs="020051" start_tfs_zulu="2013-06-05T02:00:51Z" batter="430897" stand="L" b_height="6-0" pitcher="502085" p_throws="R" des="Nick Swisher lines into a double play, second baseman Jayson Nix to shortstop Reid Brignac. Jason Kipnis doubled off 2nd. " des_es="Nick Swisher batea línea para doble matanza, segunda base Jayson Nix a campo corto Reid Brignac. Jason Kipnis doblado 2da. " event_num="556" event="Double Play" event_es="Doble-Play" home_team_runs="4" away_team_runs="3"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:dp]).to eq(1)
        expect(parser.stats[:gidp]).to eq(0)
        expect(parser.stats[:h]).to eq(0)
        expect(parser.stats[:h_2b]).to eq(0)
      end
    end

    describe "on a triple play" do
      it "records a plate appearance, at-bat, triple-play, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="18" b="0" s="0" o="3" start_tfs="235624" start_tfs_zulu="2014-04-17T23:56:24Z" batter="446481" stand="R" b_height="6-0" pitcher="282332" p_throws="L" des="Sean Rodriguez grounds into a triple play, third baseman Yangervis Solarte to second baseman Brian Roberts to first baseman Scott Sizemore. Evan Longoria out at 3rd. Wil Myers out at 2nd. " des_es="Sean Rodriguez batea rodado para triple-play, tercera base Yangervis Solarte a segunda base Brian Roberts a primera base Scott Sizemore. Evan Longoria a cabo a 3ra. Wil Myers a cabo a 2da. " event_num="144" event="Triple Play" event_es="Triple Play" home_team_runs="0" away_team_runs="4"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:tp]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
        expect(parser.stats[:h_3b]).to eq(0)
      end
    end

    describe "on a bunt lineout" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="44" b="0" s="0" o="1" start_tfs="183738" start_tfs_zulu="2015-03-13T18:37:38Z" batter="435622" stand="R" b_height="6-3" pitcher="433584" p_throws="R" des="Ian Desmond bunt lines out to pitcher Roberto Hernandez. " des_es="Ian Desmond batea toque de línea de out a lanzador Roberto Hernandez. " event_num="260" event="Bunt Lineout" event_es="Out en Línea ede Toque de Bola" home_team_runs="3" away_team_runs="4"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a bunt popout" do
      it "records a plate appearance, at-bat, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="1" b="0" s="1" o="1" start_tfs="181209" start_tfs_zulu="2015-03-07T18:12:09Z" batter="458913" stand="L" b_height="5-10" pitcher="594798" p_throws="R" des="Eric Young Jr. bunt pops out to third baseman David Wright. " des_es="Eric Young Jr. batea elevadito con toque de out a tercera base David Wright. " event_num="6" event="Bunt Pop Out" event_es="Elevado de Out en Toque de Bola" home_team_runs="0" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a reached on fielding error" do
      it "records a plate appearance, at-bat, an ROE, and no hit" do
        node = Nokogiri::XML(%q{
          <atbat num="64" b="1" s="2" o="0" start_tfs="192731" start_tfs_zulu="2015-05-09T19:27:31Z" batter="453056" stand="L" b_height="6-1" pitcher="488984" p_throws="R" des="Jacoby Ellsbury reaches on a fielding error by second baseman Ryan Flaherty. " des_es="Jacoby Ellsbury se embasa por error en fildeo de segunda base Ryan Flaherty. " event_num="491" event="Field Error" event_es="Error de Fildeo" play_guid="fbdd422f-fe2f-441f-ace1-7bcfc7e0d9ca" home_team_runs="1" away_team_runs="6"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:roe]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a hit by pitch" do
      it "records a plate appearance, a HBP, and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="72" b="0" s="0" o="1" start_tfs="205559" start_tfs_zulu="2015-03-01T20:55:59Z" batter="452105" stand="R" b_height="6-4" pitcher="661463" p_throws="R" des="John Hester hit by pitch. " des_es="John Hester golpeado por lanzamiento. " event_num="473" event="Hit By Pitch" event_es="Pelotazo" home_team_runs="2" away_team_runs="6"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:hbp]).to eq(1)
      end
    end

    describe "on a sac fly" do
      it "records a plate appearance, a sac fly, and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="16" b="0" s="1" o="1" start_tfs="183323" start_tfs_zulu="2015-03-02T18:33:23Z" batter="500207" stand="R" b_height="5-9" pitcher="650572" p_throws="R" des="Jhonatan Solano out on a sacrifice fly to right fielder Brandon Cody. Don Kelly scores. " des_es="Jhonatan Solano out con elevado de sacrificio a jardinero derecho Brandon Cody. Don Kelly anota. " event_num="88" event="Sac Fly" event_es="Elevado de Sacrificio" score="T" home_team_runs="3" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:sf]).to eq(1)
        expect(parser.stats[:sh]).to eq(0)
      end
    end

    describe "on a sac fly double play" do
      it "records a plate appearance, a sac fly, a double-play, and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="72" b="0" s="1" o="2" start_tfs="224150" start_tfs_zulu="2015-03-03T22:41:50Z" batter="458252" stand="R" b_height="5-9" pitcher="607706" p_throws="L" des="Irving Falu flies into a sacrifice double play, center fielder Jordan Smith to pitcher Michael Roth to third baseman Michael Martinez. Chris Dominguez scores. Brennan Boesch out at 3rd on the throw. " des_es="Irving Falu doble matanza con elevado de sacrificio, jardinero central Jordan Smith a lanzador Michael Roth a tercera base Michael Martinez. Chris Dominguez anota Brennan Boesch a cabo a 3ra con el tiro. " event_num="475" event="Sac Fly DP" event_es="Doble Play en Elevado de Sacrificio" score="T" home_team_runs="10" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:sf]).to eq(1)
        expect(parser.stats[:sh]).to eq(0)
        expect(parser.stats[:dp]).to eq(1)
      end
    end

    describe "on a sac bunt" do
      it "records a plate appearance, a sac bunt, and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="15" b="0" s="1" o="0" start_tfs="184040" start_tfs_zulu="2015-03-03T18:40:40Z" batter="461865" stand="L" b_height="6-1" pitcher="434622" p_throws="R" des="Andrew Romine hits a sacrifice bunt. Throwing error by pitcher Ubaldo Jimenez. Tyler Collins to 3rd. Jordan Lennerton to 2nd. Andrew Romine to 1st. " des_es="Andrew Romine se sacrifica con toque. Error en tiro de lanzador Ubaldo Jimenez. Tyler Collins a 3ra. Jordan Lennerton a 2da. Andrew Romine a 1ra. " event_num="91" event="Sac Bunt" event_es="Toque de Sacrificio" event2="Error" event2_es="Error" home_team_runs="1" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:sh]).to eq(1)
        expect(parser.stats[:sf]).to eq(0)
      end
    end

    describe "on a sac bunt double play" do
      it "records a plate appearance, a sac bunt, a GIDP, a DP, and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="20" b="2" s="1" o="3" start_tfs="182425" start_tfs_zulu="2015-04-30T18:24:25Z" batter="608641" stand="L" b_height="6-3" pitcher="571527" p_throws="R" des="Tim Cooney ground bunts into a sacrifice double play, third baseman Cody Asche to second baseman Cesar Hernandez to catcher Cameron Rupp. Pete Kozma out at 3rd. " des_es="Tim Cooney batea rodado con toque doble matanza de sacrificio, tercera base Cody Asche a segunda base Cesar Hernandez a receptor Cameron Rupp. Pete Kozma a cabo a 3ra. " event_num="159" event="Sacrifice Bunt DP" event_es="Doble Play en Toque de Bola de Sacrificio" play_guid="042858a4-9e8e-4947-a64f-fcd419b17f54" home_team_runs="3" away_team_runs="1"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:sh]).to eq(1)
        expect(parser.stats[:sf]).to eq(0)
        expect(parser.stats[:gidp]).to eq(1)
        expect(parser.stats[:dp]).to eq(1)
        expect(parser.stats[:h]).to eq(0)
      end
    end

    describe "on a fielder's choice" do
      it "records a plate appearance, an at-bat, and a fc" do
        node = Nokogiri::XML(%q{
          <atbat num="37" b="3" s="2" o="1" start_tfs="233141" start_tfs_zulu="2015-03-03T23:31:41Z" batter="605113" stand="R" b_height="6-3" pitcher="621055" p_throws="R" des="Nick Ahmed reaches on a fielder's choice out, third baseman David Greer to catcher Brian Serven to third baseman David Greer. Yasmany Tomas out at home. Tuffy Gosewisch to 2nd. " des_es="Nick Ahmed se embasa por out en jugada de selección, tercera base David Greer a receptor Brian Serven a tercera base David Greer. Yasmany Tomas a cabo a home. Tuffy Gosewisch a 2da. " event_num="318" event="Fielders Choice Out" event_es="Out en Jugada de Selección" home_team_runs="0" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:fc]).to eq(1)
      end
    end

    describe "when a half-inning ends with a caught stealing" do
      it "records a no plate appearance and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="64" b="1" s="0" o="3" start_tfs="201236" start_tfs_zulu="2015-03-02T20:12:36Z" batter="661839" stand="R" b_height="5-8" pitcher="518543" p_throws="R" des="With Rey Perez batting, Evan Holland caught stealing 2nd base, catcher Sharif Othman to second baseman Avery Romero. " des_es="Con Rey Perez bateando, Evan Holland atrapado robando la 2da base, receptor Sharif Othman a segunda base Avery Romero. " event_num="427" event="Runner Out" event_es="Corredor Out" home_team_runs="6" away_team_runs="2"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(0)
        expect(parser.stats[:ab]).to eq(0)
      end
    end

    describe "on batter interference" do
      it "records a plate appearance, an at-bat, and batter interference" do
        node = Nokogiri::XML(%q{
          <atbat num="6" b="0" s="1" o="2" start_tfs="182509" start_tfs_zulu="2015-03-04T18:25:09Z" batter="430945" stand="R" b_height="6-3" pitcher="434671" p_throws="R" des="Adam Jones grounds out to first baseman Aaron Westlake. Adam Jones out on batter interference. " des_es="Adam Jones batea rodado de out a primera base Aaron Westlake. Adam Jones out por interferencia del bateador. " event_num="30" event="Batter Interference" event_es="Interferencia del Bateador" home_team_runs="0" away_team_runs="0"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:bi]).to eq(1)
        expect(parser.stats[:ci]).to eq(0)
      end
    end

    describe "on catcher interference" do
      it "records a plate appearance, catcher interference, and no at-bat" do
        node = Nokogiri::XML(%q{
          <atbat num="63" b="3" s="2" o="0" start_tfs="224427" start_tfs_zulu="2015-03-07T22:44:27Z" batter="600303" stand="L" b_height="5-11" pitcher="457429" p_throws="L" des="Tommy La Stella reaches on catcher interference by Tommy Murphy. Tommy La Stella to 1st. " des_es="Tommy La Stella se embase por interferencia del receptor de Tommy Murphy. Tommy La Stella a 1ra. " event_num="557" event="Catcher Interference" event_es="Interferencia del Receptor" home_team_runs="7" away_team_runs="2"></atbat>
        }).search("atbat").first

        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ci]).to eq(1)
        expect(parser.stats[:ab]).to eq(0)
        expect(parser.stats[:bi]).to eq(0)
      end
    end

    describe "on fan interference" do
      let(:node) do
        Nokogiri::XML(%q{
          <atbat num="10" b="0" s="0" o="1" start_tfs="232525" start_tfs_zulu="2015-03-13T23:25:25Z" batter="571974" stand="R" b_height="5-11" pitcher="519144" p_throws="R" des="John Ryan Murphy hits a ground-rule double (1) on a line drive down the right-field line, on fan interference. " des_es="John Ryan Murphy pega doble por reglas de terreno (1) con línea por la raya del jardín derecho, por interferencia de un aficionado. " event_num="54" event="Fan interference" event_es="Interferencia de un Fan" home_team_runs="1" away_team_runs="0"></atbat>
        }).search("atbat").first
      end

      it "records a plate appearance, an at-bat, fan interference, and a hit" do
        parser = described_class.new(node)

        expect(parser.stats[:pa]).to eq(1)
        expect(parser.stats[:ab]).to eq(1)
        expect(parser.stats[:h]).to eq(1)
        expect(parser.stats[:fi]).to eq(1)
      end

      it "records the correct kind of hit" do
        parser = described_class.new(node)

        expect(parser.stats[:h_2b]).to eq(1)
      end
    end
  end
end
