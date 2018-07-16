#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# ------------------------------------------------------------------------------------
library(shiny)
library(data.table)
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
                                             font-size: 16px;
                                             }
                                             h3 {
                                             font-size: 16px;
                                             }
                                             ')  
                            )),	
                  navbarPage(strong("ColorectalCancer"),
                             tabPanel(strong("Home") ,
                                      fluidRow(
                                        column(10,includeMarkdown("docs/Introduction.md"))
                                      ),
                                      sidebarLayout(
                                        sidebarPanel(strong("Work Flow of Website"),style="font-size:20px"),
                                        
                                        mainPanel(
                                          img(src="overview.png",height=400,width=600)
										 
                                          )
                                        )
                             ),
                             tabPanel(strong("Upload"),
                                      sidebarPanel(
                                        helpText(a("Click Here for the Source Code on Github!", href = "https://github.com/medxiaorudan/ColorectalCancer/", target = "_blank")),
                                        fileInput("filename", "Choose VCF File to Upload:"),
                                        checkboxInput('header', 'Header', FALSE)
                                      ),
                                      mainPanel(
                                        h3("从dbSNP数据库中提取结直肠癌癌风险位点库中的rs位点信息，dbSNP数据库版本为dbSNP147，参考基因组版本为GRCh37.p13。
                                           然后寻找结直肠癌中连锁的rs位点，以连锁区域的30k为界限去除连锁位点，保留P值最显著的rs位点。
                                           随后，从千人基因组的VCF文件中提取结直肠癌风险位点库中收集的rs位点。"),
                                        plotOutput('plot'),
                                        h2("绿色曲线为千人基因组人群结直肠癌遗传风险值密度曲线，条状热图从绿色到红色表示遗传风险从低到高，上传vcf文件后会以三角形指示您风险值对应的位置",style = "font-family: 'Cyborg', cursive; line-height: 1.1; color: forestgreen;")
                                        ),
                                      
                                      h3("与千人基因组人群相比，您的相对遗传风险值:",style = "font-family: 'Cyborg', cursive; line-height: 1.1; color: navy;"),
                                      textOutput("range")
                                      ),
                             tabPanel(strong("About") ,
                                      fluidRow(
                                        column(10,includeMarkdown("docs/About.md"))
                                      ))
                  )))


