<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

    <!-- guest name -->
    <xsl:param name="name" />
    <!-- module options -->
    <xsl:param name="options" select="/expr/attrs" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <!-- generate config from module options for a single domain (see domain.nix) -->
    <xsl:template match="/">
        <xsl:param name="template" select="document('./template.xml')" />
        <xsl:apply-templates select="$template/domain" />
    </xsl:template>

    <xsl:template match="domain">
        <xsl:copy>
            <xsl:attribute name="type">kvm</xsl:attribute>
            <xsl:apply-templates select="*" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="domain/name">
        <xsl:copy>
            <xsl:value-of select="$name" />
        </xsl:copy>
    </xsl:template>

    <!-- merge host devices from options into existing devices -->
    <xsl:template match="devices">
        <xsl:copy>
            <!-- TODO: handle conflicts with existing hostdev nodes, if present?
                a hostdev for the same pci address may exist both in the
                template and in the module options, which will result in invalid
                configuration due to conflicting hostdev nodes. either merge
                them here or ensure all possible options can be set via the
                module.
            -->
            <xsl:apply-templates select="$options/attr[@name='hostDevices']" />
            <xsl:apply-templates select="*" />
        </xsl:copy>
    </xsl:template>

    <!-- hostdevs from module options -->
    <xsl:template match="attr[@name='hostDevices']">
        <xsl:for-each select="attrs/attr[@name='usb']/list/attrs">
            <hostdev mode="subsystem" type="usb" managed="yes">
                <source startupPolicy="{attr[@name='startupPolicy']/string/@value}">
                    <vendor id="0x{attr[@name='vendorId']/string/@value}" />
                    <product id="0x{attr[@name='productId']/string/@value}" />
                </source>
            </hostdev>
            <!-- TODO: support bus address -->
        </xsl:for-each>

        <xsl:for-each select="attrs/attr[@name='pci']/list/attrs">
            <xsl:variable name="bus" select="attr[@name='bus']/string/@value" />
            <xsl:variable name="slot" select="attr[@name='slot']/string/@value" />

            <!-- each function is a distinct hostdev node -->
            <xsl:for-each select="attr[@name='functions']/list/string">
                <hostdev mode="subsystem" type="pci" managed="yes">
                    <driver name="vfio" />
                    <source>
                        <address domain="0x0000" bus="0x{$bus}" slot="0x{$slot}" function="0x{@value}" />
                        <!-- TODO: support alias -->
                    </source>
                </hostdev>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
