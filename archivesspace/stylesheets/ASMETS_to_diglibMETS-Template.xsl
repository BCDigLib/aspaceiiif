<?xml version="1.0" encoding="UTF-8"?>

 <!--
        *******************************************************************
        *                                                                 *
        * VERSION:          1. 01                                         *
        *                                                                 *
        * AUTHOR:           Betsy Post                                    *
        *                   betsy.post@bc.edu                             *
        *                                                                 *
        *                                                                 *
        * ABOUT:           This file has been created to convert          *
        *                  Archivists' Toolkit METS/MODS into a form      *
        *                  suitable for use in the Boston College         *
        *                  Digital Library. Oct 30, 2011                  *
        *                                                                 *
        * UPDATED:         Aug 30, 2016                                  *
        *                                                                 *
        * USE:             Convert Archivists Toolkit MODS/METS to conform*
        *                  with Boston College and Digital Commonwealth   *
        *                  requirements.                                  *
        *                                                                 *
        * UPDATED:         May 2017                                       *
        *                                                                 *
        *USE:              Updated May 2017 by Chris Mayo to transform    *
        *                  METS/MODS output by ArchivesSpace 2.0          *
        *                  This usage requires a copy of the collection's *
        *                  EAD as output by ASpace to be in the same      *
        *                  directory and titled 'ead.xml'.                *
        *******************************************************************
    -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
    version="2.0">
    <xsl:variable name="ead" select="document('ead.xml')"/>
    <xsl:variable name="unitTitle" select="mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:titleInfo/mods:title[1]"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <!--Identity Template.  This version of the Identity Template does not copy over namespaces.  
        Nodes that need special processing other than copying have their own template below the 
        Identity Template-->

    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="substring(name(),1,4)='mods'">
                <xsl:element name="{name()}">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{'mets:'}{name()}">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@*|text()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>
    <!--End of Identity Template-->
    
    <!-- Avoid processing of dmdSecs subsequent to the first -->
    <xsl:template match="mets:dmdSec[position() != 1]"/>

    <!--Special templates for selected mods nodes-->
    
    <xsl:template match="mods:mods">
        <mods:mods
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates/>
        </mods:mods>
    </xsl:template>

    <!--(1)mods:titleInfo; Digital Commonwealth requires usage-->
    <!-- Not handling nonSort; does DACS allow nonSort?-->

    <xsl:template match="mods:titleInfo">
        <mods:titleInfo usage="primary">
            <xsl:apply-templates/>
        </mods:titleInfo>
    </xsl:template>

    <!--(2)mods:name and (3)mods:typeOfResource-->
    <!--(4) genre (one genre with a broad value displayLabel from Digital Commonwealth list required -->

    <xsl:template match="mods:name"/>
    
    <xsl:template match="mods:typeOfResource">
        <xsl:for-each select="following-sibling::mods:name[@type='personal']">
            <mods:name authority="naf" type="personal">
                <mods:namePart type='family'><xsl:value-of select="mods:namePart[@type='family']"/></mods:namePart>
                <mods:namePart type='given'><xsl:value-of select="mods:namePart[@type='given']"/></mods:namePart>
                <mods:namePart type='date'><xsl:value-of select="mods:namePart[@type='date']"/></mods:namePart>
                <mods:displayForm><xsl:value-of select="mods:displayForm"/></mods:displayForm>
                <mods:role>
                    <mods:roleTerm type='text' authority="marcrelator"><xsl:value-of select="upper-case(substring(mods:role/mods:roleTerm[@type='text'],1,1))"/><xsl:value-of select="substring(mods:role/mods:roleTerm[@type='text'],2,string-length(.))"/></mods:roleTerm>
                    <mods:roleTerm type='code' authority="marcrelator"><xsl:value-of select="mods:role/mods:roleTerm[@type='code']"/></mods:roleTerm>
                </mods:role>
            </mods:name>
        </xsl:for-each>
        <mods:name authority="naf" type="corporate">
            <mods:namePart>Boston College</mods:namePart>
            <mods:namePart>John J. Burns Library</mods:namePart>
            <mods:displayForm>Boston College. John J. Burns Library</mods:displayForm>
            <mods:role>
                <mods:roleTerm type="code" authority="marcrelator">own</mods:roleTerm>
                <mods:roleTerm type="text" authority="marcrelator">Owner</mods:roleTerm>
            </mods:role>
        </mods:name>
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
        <!--project dependent-->
        <mods:genre authority="gmgpc" displayLabel="general">Prints</mods:genre>
    </xsl:template>

    <!--(5)mods:originInfo; (6) mods:language
    This is handled off mods:language because originInfo has to be pulled from the EAD-->

    <xsl:template match="mods:language[1]">
        
        <mods:originInfo>
            <xsl:choose>
                <xsl:when test="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,1,4)=substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,6,9)">
                    <mods:dateCreated>
                        <xsl:value-of select="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,1,4)"/>
                    </mods:dateCreated>
                    <mods:dateCreated encoding="w3cdtf" keyDate="yes">
                        <xsl:value-of select="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,1,4)"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <mods:dateCreated>
                        <xsl:value-of select="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,1,4)"/>-<xsl:value-of select="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,6,9)"/>
                    </mods:dateCreated>
                    <mods:dateCreated encoding="w3cdtf" point="start" keyDate="yes">
                        <xsl:value-of select="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,1,4)"/>
                    </mods:dateCreated>
                    <mods:dateCreated encoding="w3cdtf" point="end">
                        <xsl:value-of select="substring($ead//ead:unittitle[$unitTitle]/following-sibling::ead:unitdate/@normal,6,9)"/>
                    </mods:dateCreated>
                </xsl:otherwise>
            </xsl:choose>
            <mods:issuance>monographic</mods:issuance>
        </mods:originInfo>

        <!--(6)mods:language.  The mods:language element term is the second one output in toolkit EAD.  
        To re-arrange the elements, this template is here and the output is happening in the mods:origin template now -->
        <!-- This is currently only handling English and No Linguistic Content - we should make a helper file that maps
            codes to text values, since Aspace is only outputting the code. -->

        <mods:language>
            <mods:languageTerm type="code" authority="iso639-2b">
                <xsl:value-of select="mods:languageTerm[@type='code']"/>
            </mods:languageTerm>
            <xsl:choose>
                <xsl:when test="mods:languageTerm[@type='code']='eng'">
            <mods:languageTerm type="text" authority="iso639-2b">English</mods:languageTerm>
                </xsl:when>
                <xsl:when test="mods:languageTerm[@type='code']='zxx'">
                    <mods:languageTerm type="text" authority="iso639-2b">No linguistic content</mods:languageTerm>        
                </xsl:when>
            </xsl:choose>    
        </mods:language>
    </xsl:template>

    <!--(6)mods:language is processed in originInfo template-->

    <xsl:template match="mods:language"/>


    <!-- (7) mods:physicalDescription contains both constant and added data -->
    <!-- relatedItem info must currently be tacked on to physical description so it can pull from other file-->
 
    <xsl:template match="mods:physicalDescription">
        <mods:physicalDescription>
            <mods:form authority="marcform">electronic</mods:form>
            <!-- Internet Media Type - needs further development to handle the case where there
                are multiple internet media types (delimted by a semi-colon-->
            <mods:internetMediaType>
                <xsl:value-of
                    select="following-sibling::mods:note[3]"
                />
            </mods:internetMediaType>
            <mods:extent unit="level/digital surrogates">
                <xsl:value-of select="following-sibling::mods:note[@type='dimensions']"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of
                    select="/mets:mets/mets:structMap[@TYPE='physical']/mets:div[last()]/@ORDER"/>
                <xsl:choose>
                    <xsl:when
                        test="/mets:mets/mets:structMap[@TYPE='physical']/mets:div[last()]/@ORDER >1 ">
                        <xsl:text> digital surrogates)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> digital surrogate)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </mods:extent>
            <mods:digitalOrigin>
                <xsl:value-of select="following-sibling::mods:note[2]"/>
            </mods:digitalOrigin>
            <!-- Not sure what's up with the dimensions of original note - something for the Japanese prints? -->
           <!-- <mods:note type="physical details">Dimensions of Original: <xsl:value-of select="mods:note[@displayLabel='General Physical Description note']"/></mods:note> -->
        </mods:physicalDescription>
        <mods:accessCondition type="useAndReproduction" displayLabel="Conditions Governing Use note"><xsl:value-of select="following-sibling::mods:accessCondition"/></mods:accessCondition>
        <xsl:variable name="collectionTitle" select="$ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unittitle"/>
        <mods:relatedItem type="host">
            <mods:titleInfo usage="primary">
                <mods:title><xsl:value-of select="$collectionTitle"/></mods:title>
            </mods:titleInfo>
            <mods:originInfo>
                <mods:dateCreated><xsl:value-of 
                    select="substring($ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitdate/@normal,1,4)"/>-<xsl:value-of
                        select="substring($ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitdate/@normal,6,9)"/></mods:dateCreated>
                <mods:dateCreated encoding="w3cdtf" point="start" keyDate="yes"><xsl:value-of select="substring($ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitdate/@normal,1,4)"/></mods:dateCreated>
                <mods:dateCreated encoding="w3cdtf" point="end"><xsl:value-of select="substring($ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitdate/@normal,6,9)"/></mods:dateCreated>
            </mods:originInfo>
            <mods:identifier type="accession number"><xsl:value-of select="$ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitid"/></mods:identifier>
            <mods:location>
                <mods:url displayLabel="{$collectionTitle}"><xsl:value-of
                    select="$ead/ead:ead/ead:eadheader/ead:eadid/@url"/></mods:url>
            </mods:location>
        </mods:relatedItem>
    </xsl:template>
    
    <!-- Stop the notes from coming out twice-->
    <xsl:template match="mods:accessCondition"/>

    <xsl:template match="mods:note"/>


    <!--(11) Omit toolkit note.  (19) mods:extentsion; (20) mods:recordInfo-->
    <xsl:template match="mods:note[@displayLabel='Digital object made available by']">
        <mods:extension>
            <localCollectionName>
                <xsl:value-of
                    select="translate($ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitid,'.','')"
                />
            </localCollectionName>
        </mods:extension>
        <mods:recordInfo>
            <mods:recordContentSource>Boston College</mods:recordContentSource>
            <mods:recordOrigin>Boston College/ArchiveSpace Batch DAO</mods:recordOrigin>
            <mods:languageOfCataloging>
                <mods:languageTerm type="text">English</mods:languageTerm>
                <mods:languageTerm type="code" authority="iso639-2b">eng</mods:languageTerm>
            </mods:languageOfCataloging>
            <mods:descriptionStandard authority="marcdescription">dacs</mods:descriptionStandard>
        </mods:recordInfo>
    </xsl:template>

    <!--Special templates for selected mets nodes-->
    <xsl:template match="mets:mets">
        <xsl:variable name="itemTitle" select="mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:titleInfo/mods:title"/>
        <mets:mets
            xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd">
            <xsl:attribute name="OBJID">
                <xsl:value-of select="@OBJID"/>
            </xsl:attribute>
            <xsl:attribute name="LABEL">
                <xsl:value-of select="$itemTitle"/>
            </xsl:attribute>
            <xsl:attribute name="TYPE">
                <xsl:value-of select="@TYPE"/>
            </xsl:attribute>
            <xsl:attribute name="PROFILE">ArchivesSpace</xsl:attribute>
            <xsl:apply-templates/>
        </mets:mets>
    </xsl:template>

    <!-- fix timestamp and re-order notes in mets:Hdr -->
    <xsl:template match="mets:metsHdr">
        <mets:metsHdr>
            <xsl:attribute name="CREATEDATE">
                <xsl:value-of select="concat(substring(@CREATEDATE,1,10),'T',substring(@CREATEDATE,12,8))"/>
            </xsl:attribute>
        </mets:metsHdr>
    </xsl:template>
    
    <!-- Add 'dm' prefix to ID assigned by ASpace-->
    <xsl:template match="mets:dmdSec">
        <mets:dmdSec>
            <xsl:attribute name="ID">
                <xsl:value-of select="concat('dm',@ID)"/>
            </xsl:attribute>
            <xsl:apply-templates/>   
        </mets:dmdSec>
    </xsl:template>
    
    <!-- add XML mimetype to mcWrap-->
    <xsl:template match="mets:mdWrap">
        <mets:mdWrap MIMETYPE="text/xml" MDTYPE="MODS">
            <xsl:apply-templates/>
        </mets:mdWrap>
    </xsl:template>
    
    <!--Add amdsec with preservation md-->
    <xsl:template match="mets:fileSec">
        <mets:amdSec>
            <mets:digiprovMD ID="dp01">
                <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="preservation_md">
                    <mets:xmlData>
                        <premis xmlns="info:lc/xmlns/premis-v2"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.1"
                            xsi:schemaLocation="info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd">
                            <!-- premis file object -->
                            <object xsi:type="file">
                                <objectIdentifier>
                                    <objectIdentifierType>handle</objectIdentifierType>
                                    <objectIdentifierValue>
                                        <xsl:value-of
                                            select="normalize-space(substring(ancestor::mets:mets/@OBJID,23))"
                                        />
                                    </objectIdentifierValue>
                                </objectIdentifier>
                                <preservationLevel>
                                    <preservationLevelValue/>
                                </preservationLevel>
                                <objectCharacteristics>
                                    <compositionLevel>0</compositionLevel>
                                    <fixity>
                                        <messageDigestAlgorithm/>
                                        <messageDigest/>
                                    </fixity>
                                    <format>
                                        <formatRegistry>
                                            <formatRegistryName/>
                                            <formatRegistryKey/>
                                        </formatRegistry>
                                    </format>
                                </objectCharacteristics>
                            </object>
                        </premis>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:digiprovMD>
        </mets:amdSec>
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <!--mets:file add mimetype and sequence number, to make sure thumbnails show up after the ingest -->
    <xsl:template match="mets:file">
        <mets:file>
            <xsl:attribute name="SEQ">
                <xsl:number level="single" count="mets:file"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@USE='archive image'">
                    <xsl:attribute name="MIMETYPE">image/tiff</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="MIMETYPE">image/jpeg</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="ID">
                <xsl:value-of select="concat('FID',@ID)"/>
            </xsl:attribute>
            <xsl:attribute name="GROUPID">
                <xsl:value-of select="@GROUPID"/>
            </xsl:attribute>
            <xsl:attribute name="USE">
                <xsl:value-of select="ancestor::mets:fileGrp/@USE"/>
            </xsl:attribute>
                <mets:FLocat>
                    <xsl:attribute name="LOCTYPE">URL</xsl:attribute>
                    <xsl:attribute name="xlink:type">simple</xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="concat('file://streams/', mets:FLocat/@xlink:href)"/>
                    </xsl:attribute>
                </mets:FLocat>
        </mets:file>
    </xsl:template>
    <!--Omit logical structMap-->
    <xsl:template match="mets:structMap[@TYPE='logical']"/>
    <xsl:template match="mets:structMap[@TYPE='physical']">
        <!-- Explicitly set first level div because ASpace doesn't output it -->
        <mets:structMap TYPE='physical'>
            <mets:div>
                <xsl:attribute name="ORDER">1</xsl:attribute>
                <xsl:attribute name="LABEL">
                    <xsl:value-of
                        select="$ead/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitid"
                    />
                </xsl:attribute>
                <xsl:attribute name="DMDID">
                    <xsl:value-of select="concat('dm',preceding::mets:dmdSec/@ID)"/>
                </xsl:attribute>
                <xsl:attribute name="TYPE">DAO</xsl:attribute>
                <xsl:for-each select="mets:div">
                    <mets:div>
                        <xsl:attribute name="ORDER">
                            <xsl:value-of select="@ORDER"/>   
                        </xsl:attribute>
                        <xsl:attribute name="LABEL">
                            <xsl:value-of select="@LABEL"/>
                        </xsl:attribute>
                        <xsl:attribute name="TYPE">DAOcomponent</xsl:attribute>
                        
                        <xsl:for-each select="mets:fptr">
                            <mets:fptr>
                                <xsl:attribute name="FILEID">
                                    <xsl:value-of select="concat('FID',@FILEID)"/>
                                </xsl:attribute>
                            </mets:fptr>
                        </xsl:for-each> 
                    </mets:div>    
                </xsl:for-each>
            </mets:div>
        </mets:structMap>
    </xsl:template>
   
    <xsl:template match="mets:fptr"/>
</xsl:stylesheet>
