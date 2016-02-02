<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="XLXN_2" />
        <signal name="XLXN_4" />
        <signal name="CLK" />
        <signal name="RST" />
        <signal name="PS2_CLK" />
        <signal name="PS2_DATA" />
        <signal name="LED" />
        <signal name="XLXN_17" />
        <port polarity="Input" name="CLK" />
        <port polarity="Input" name="RST" />
        <port polarity="BiDirectional" name="PS2_CLK" />
        <port polarity="BiDirectional" name="PS2_DATA" />
        <port polarity="Output" name="LED" />
        <blockdef name="Keyboard_Controller">
            <timestamp>2015-2-8T5:31:4</timestamp>
            <rect width="256" x="64" y="-256" height="256" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="Debug_Unit">
            <timestamp>2015-2-8T5:35:16</timestamp>
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="368" y1="-160" y2="-160" x1="416" />
            <rect width="304" x="64" y="-192" height="192" />
        </blockdef>
        <block symbolname="Debug_Unit" name="XLXI_2">
            <blockpin signalname="XLXN_1" name="ASCII_BUS" />
            <blockpin signalname="XLXN_2" name="ASCII_RD" />
            <blockpin signalname="XLXN_4" name="ASCII_WE" />
            <blockpin signalname="LED" name="Debug_OUT" />
        </block>
        <block symbolname="Keyboard_Controller" name="XLXI_1">
            <blockpin signalname="CLK" name="CLK" />
            <blockpin signalname="RST" name="RST" />
            <blockpin signalname="PS2_CLK" name="PS2_CLK" />
            <blockpin signalname="PS2_DATA" name="PS2_DATA" />
            <blockpin signalname="XLXN_1" name="ASCII_OUT" />
            <blockpin signalname="XLXN_2" name="ASCII_RD" />
            <blockpin signalname="XLXN_4" name="ASCII_WE" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="1760" height="1360">
        <instance x="944" y="752" name="XLXI_2" orien="R0">
        </instance>
        <branch name="XLXN_1">
            <wire x2="928" y1="592" y2="592" x1="832" />
            <wire x2="944" y1="592" y2="592" x1="928" />
        </branch>
        <branch name="XLXN_2">
            <wire x2="928" y1="656" y2="656" x1="832" />
            <wire x2="944" y1="656" y2="656" x1="928" />
        </branch>
        <instance x="448" y="816" name="XLXI_1" orien="R0">
        </instance>
        <branch name="XLXN_4">
            <wire x2="928" y1="720" y2="720" x1="832" />
            <wire x2="944" y1="720" y2="720" x1="928" />
        </branch>
        <branch name="CLK">
            <wire x2="448" y1="592" y2="592" x1="416" />
        </branch>
        <iomarker fontsize="28" x="416" y="592" name="CLK" orien="R180" />
        <branch name="RST">
            <wire x2="448" y1="656" y2="656" x1="416" />
        </branch>
        <iomarker fontsize="28" x="416" y="656" name="RST" orien="R180" />
        <branch name="PS2_CLK">
            <wire x2="448" y1="720" y2="720" x1="416" />
        </branch>
        <iomarker fontsize="28" x="416" y="720" name="PS2_CLK" orien="R180" />
        <branch name="PS2_DATA">
            <wire x2="448" y1="784" y2="784" x1="416" />
        </branch>
        <iomarker fontsize="28" x="416" y="784" name="PS2_DATA" orien="R180" />
        <branch name="LED">
            <wire x2="1376" y1="592" y2="592" x1="1360" />
            <wire x2="1440" y1="480" y2="480" x1="1376" />
            <wire x2="1376" y1="480" y2="592" x1="1376" />
        </branch>
        <iomarker fontsize="28" x="1440" y="480" name="LED" orien="R0" />
    </sheet>
</drawing>