library(shiny)
library(data.table)
library(limma)
library(tools)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("spacelab"),
                  tags$head(includeScript("layout.js"),
   tags$style (HTML('
        body, label, input, button, select { 
            font-family: "Calibri";
            background-color: linen;
        }
		h2 {
			font-size: 18px;
            }
		h3 {
			font-size: 18px;
            }
		')  
				  )),	
navbarPage("ColorectalCancer",tabPanel("Home",
    sidebarPanel(
    helpText(a("Click Here for the Source Code on Github!", href = "https://github.com/medxiaorudan/ColorectalCancer/", target = "_blank")),
    fileInput("filename", "Choose VCF File to Upload:"),
		checkboxInput('header', 'Header', FALSE)
  	),
mainPanel(
    plotOutput('plot'),
   	h2("绿色曲线为千人基因组人群结直肠癌遗传风险值密度曲线，条状热图从绿色到红色表示遗传风险从低到高，上传vcf文件后会以三角形指示您风险值对应的位置",style = "font-family: 'Cyborg', cursive; line-height: 1.1; color: forestgreen;")
 ),

	  h3("与千人基因组人群相比，您的相对遗传风险值:",style = "font-family: 'Cyborg', cursive; line-height: 1.1; color: navy;"),
	  textOutput("range")
 ),

 
tabPanel("About" ,
         fluidRow(
           column(10,includeMarkdown("docs/introduction.md"))
         ))
)))

