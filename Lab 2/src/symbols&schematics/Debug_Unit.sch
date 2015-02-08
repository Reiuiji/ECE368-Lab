<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_5" />
        <signal name="XLXN_6" />
        <signal name="OPCODE" />
        <signal name="REGA" />
        <signal name="REGB" />
        <signal name="XLXN_4(15:0)" />
        <signal name="XLXN_11(15:0)" />
        <signal name="XLXN_15" />
        <signal name="ASCII_BUS" />
        <signal name="ASCII_RD" />
        <signal name="ASCII_WE" />
        <port polarity="Output" name="OPCODE" />
        <port polarity="Output" name="REGA" />
        <port polarity="Output" name="REGB" />
        <port polarity="Input" name="ASCII_BUS" />
        <port polarity="Input" name="ASCII_RD" />
        <port polarity="Input" name="ASCII_WE" />
        <blockdef name="Operation_Watcher">
            <timestamp>2015-2-8T5:42:40</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="RegA_Monitor">
            <timestamp>2015-2-8T5:43:41</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="RegB_Monitor">
            <timestamp>2015-2-8T5:44:46</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="ASCII_BUFFER">
            <timestamp>2015-2-8T6:1:53</timestamp>
            <rect width="320" x="64" y="-236" height="236" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-160" y2="-160" x1="448" />
        </blockdef>
        <block symbolname="Operation_Watcher" name="XLXI_1">
            <blockpin signalname="XLXN_4(15:0)" name="ASCII_OP" />
            <blockpin signalname="OPCODE" name="OPCODE" />
        </block>
        <block symbolname="RegA_Monitor" name="XLXI_2">
            <blockpin signalname="XLXN_4(15:0)" name="RegA_ASCII" />
            <blockpin signalname="REGA" name="REGA" />
        </block>
        <block symbolname="RegB_Monitor" name="XLXI_3">
            <blockpin signalname="XLXN_4(15:0)" name="RegB_ASCII" />
            <blockpin signalname="REGB" name="REGB" />
        </block>
        <block symbolname="ASCII_BUFFER" name="XLXI_26">
            <blockpin signalname="ASCII_BUS" name="ASCII_BUS" />
            <blockpin signalname="ASCII_RD" name="ASCII_RD" />
            <blockpin signalname="ASCII_WE" name="ASCII_WE" />
            <blockpin signalname="XLXN_4(15:0)" name="ASCII_BUFFER" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1824" y="1280" name="XLXI_1" orien="R0">
        </instance>
        <instance x="1824" y="1456" name="XLXI_2" orien="R0">
        </instance>
        <instance x="1824" y="1632" name="XLXI_3" orien="R0">
        </instance>
        <branch name="OPCODE">
            <wire x2="2224" y1="1248" y2="1248" x1="2208" />
            <wire x2="2320" y1="1248" y2="1248" x1="2224" />
        </branch>
        <branch name="REGA">
            <wire x2="2224" y1="1424" y2="1424" x1="2208" />
            <wire x2="2320" y1="1424" y2="1424" x1="2224" />
        </branch>
        <branch name="REGB">
            <wire x2="2224" y1="1600" y2="1600" x1="2208" />
            <wire x2="2320" y1="1600" y2="1600" x1="2224" />
        </branch>
        <branch name="XLXN_4(15:0)">
            <wire x2="1680" y1="1424" y2="1424" x1="1232" />
            <wire x2="1824" y1="1424" y2="1424" x1="1680" />
            <wire x2="1680" y1="1424" y2="1600" x1="1680" />
            <wire x2="1824" y1="1600" y2="1600" x1="1680" />
            <wire x2="1824" y1="1248" y2="1248" x1="1680" />
            <wire x2="1680" y1="1248" y2="1424" x1="1680" />
        </branch>
        <iomarker fontsize="28" x="2320" y="1600" name="REGB" orien="R0" />
        <iomarker fontsize="28" x="2320" y="1424" name="REGA" orien="R0" />
        <iomarker fontsize="28" x="2320" y="1248" name="OPCODE" orien="R0" />
        <branch name="ASCII_BUS">
            <wire x2="784" y1="1424" y2="1424" x1="720" />
        </branch>
        <branch name="ASCII_RD">
            <wire x2="784" y1="1488" y2="1488" x1="720" />
        </branch>
        <branch name="ASCII_WE">
            <wire x2="784" y1="1552" y2="1552" x1="720" />
        </branch>
        <instance x="784" y="1584" name="XLXI_26" orien="R0">
        </instance>
        <iomarker fontsize="28" x="720" y="1424" name="ASCII_BUS" orien="R180" />
        <iomarker fontsize="28" x="720" y="1488" name="ASCII_RD" orien="R180" />
        <iomarker fontsize="28" x="720" y="1552" name="ASCII_WE" orien="R180" />
    </sheet>
</drawing>