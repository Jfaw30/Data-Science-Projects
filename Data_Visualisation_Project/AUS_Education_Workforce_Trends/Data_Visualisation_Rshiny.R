# List of packages to check and install
packages <- c("shiny", "leaflet", "dplyr", "sf", "rnaturalearth", 
              "rnaturalearthdata", "htmltools", "plotly", "tidyr", "RColorBrewer")

# Function to check and install packages
check_and_install <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Apply the function to each package
sapply(packages, check_and_install)

 
library(shiny)
library(leaflet)
library(dplyr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(htmltools)
library(plotly)
library(tidyr)
library(RColorBrewer)

# Load data
data <- read.csv("Enrolment_data.csv")

# Convert enrollment count to millions
data$ENROLLMENT_COUNT <- data$ENROLLMENT_COUNT / 1e6

# Ensure STATE column is treated as a factor for better handling
data$STATE <- as.factor(data$STATE)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        font-family: 'Arial', sans-serif;
        background-color: #f8f9fa;
        color: #333;
      }
      .navbar {
        background-color: #e9ecef;
        color: black;
      }
      .navbar-brand, .navbar-nav li a {
        color: white !important;
      }
      .well {
        background-color: #e9ecef;
        border: none;
        border-radius: 10px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      }
      .panel-heading {
        background-color: #e9ecef !important;
        color: white !important;
        font-size: 18px;
        font-weight: bold;
        padding: 10px;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
      }
      .panel-body {
        background-color: white;
        border: 1px solid #ddd;
        border-top: none;
        border-bottom-left-radius: 30px;
        border-bottom-right-radius: 30px;
        padding: 10px;
      }
      .plot-container {
        background-color: white;
        border: 1px solid #ddd;
        border-radius:10px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        margin-top: 10px;
        padding: 10px;
      }
      #map {
        height: 400px;
        width: 100%;
        position: relative;
      }
      .control-panel {
        background-color: #e9ecef;
        color: black;
        border: none;
        border-radius: 10px;
        padding: 10px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        margin-bottom: 10px;
      }
      .leaflet-tooltip {
        font-size: 15px !important; 
      }
      .title {
        text-align: center;
      }
      .slider-container {
        position: absolute;
        bottom: 20px;
        left: 30px;
        background-color: Greens;
        padding: 10px;
        border-radius: 10px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
      }
  
    "))
  ),
  
  titlePanel(div(class="title","Distribution of Domestic and International Student Enrollment in Educational Sectors that are Linked to Australia's Skill Shortage (2018-2022)")),
  
  fluidRow(
    column(12,
           wellPanel(
             tags$style(HTML("
             .overview-heading {
               font-weight: bold;
               font-size: 24px;
             }
             .overview-paragraph {
               font-size: 19px;
             }
             .well {
               height: auto;  /* Adjusted height to auto for dynamic content */
               padding: 15px;
             }
           ")),
             h4(class = "overview-heading", "Overview:"),
             p(class = "overview-paragraph", 
               "Australia's competitiveness in the global market is heavily reliant on 
               its talented labor. However, critical areas such as engineering, 
               information technology, health care, education, architecture, management
               & commerce, and agriculture fields confront severe skill shortages. 
               This project analyzes how educational enrollments are responding to 
               these issues, highlighting the critical contributions of both domestic 
               and international students. The below dashboard gives a comprehensive
               understanding of enrollment trends and patterns in enrollment of domestic
               and international students in the above mentioned educations fields between 
               the years 2018 to 2022 for all 7 states of Australia.")
           )
    )
  ),
  
  fluidRow(
    column(3,
           div(class = "control-panel",
               div(class = "instructions-box",
                   htmlOutput("dynamicInstructions")
               )
           )
    ),
    
    column(9,
           fluidRow(
             column(12,
                    div(class = "plot-container",
                        leafletOutput("map", height = 450),
                        div(class = "slider-container",
                            sliderInput("year", "Select Year Range:",
                                        min = 2018, max = 2022,
                                        value = c(2018, 2022),
                                        step = 1,
                                        sep = "", animate = TRUE,
                                        width = '100%'),
                            htmlOutput("totalEnrollmentCount")
                        )
                    )
             )
           ),
           fluidRow(
             column(6,
                    div(class = "plot-container",
                        plotlyOutput("spiderPlot", height = 550,width = "101%"),
                        actionButton("togglePercentages", "Display Percentage", style = "position: absolute; top: 10px; left: 10px; z-index: 10;")
                    )
             ),
             column(6,
                    div(class = "plot-container",
                        plotlyOutput("trendPlot", height = 550,width = "101%")
                    )
             )
           ),
           fluidRow(
             column(12,
                    div(class = "horizontal-box",
                        HTML(paste(
                          "<style>
          ul { margin-left: 0; padding-left: 0; }
          li { margin-left: 20px; padding-left: 0; list-style-position: inside; font-size: 17px; }
          h4 { font-size: 24px; font-weight: bold; }
          h5 { font-size: 20px; font-weight: bold; }
          p { font-size: 18px; }
          .horizontal-box {
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-top: 10px;
            padding: 15px;
            height: auto;  /* Adjusted height to fit content */
          }
        </style>",
                          "<h4>Instructions</h4>",
                          "<p>This Dashboard is interactive, allowing you to view data visualizations for single or multiple states. Note, the dashboard has better visibility when the page is zoomed out at 67%.</p>",
                          "<h5>Layout</h5>",
                          "<ul>",
                          "<li><strong>Time Slider:</strong> Located at the bottom left corner, below the map section. Adjust the time slider to update trends, patterns, and enrollment data counts on all three graphs.</li>",
                          "<li><strong>Visuals:</strong> On the right side of the page, there are three visualizations:",
                          "<ul>",
                          "<li><strong>Choropleth Map:</strong> Displays the enrollment counts for Australian states (Western Australia, Northern Territory, South Australia, New South Wales, Queensland, Victoria, and Tasmania). Hovering over a state will show a tooltip with total enrollment and the breakdown between domestic and overseas students.</li>",
                          "<li><strong>Spider Plot:</strong> Shows the enrollment ratios of domestic vs. overseas students in various education fields that contribute towards skill shortage. You can filter the ratios by selecting the legends i.e. domestic and overseas which are located on the top right corner of the map, you can also rotate the spider plot to match the percentage scale on it. Hovering over the solid circles of the chart will show tooltips for respective education field enrollment ratios. You can also display the respective percentage ratios on the graph by selecting the 'Display Percentage' button located on the top left corner of the spider chart layout.</li>",
                          "<li><strong>Line Graph:</strong> Displays the trend of enrollment for the selected filters over time. Hovering over a solid circle on the chart will show a tooltip with total enrollment count</li>",
                          "</ul></li>",
                          "</ul>",
                          "<h5>Interaction and in-built filter features</h5>",
                          "<ul>",
                          "<li><strong>Hovering:</strong>",
                          "<ul>",
                          "<li><strong>Choropleth Map:</strong> Hovering over a state will display a tooltip with enrollment details. The spider plot below will update to show enrollment ratios and the line graph will show enrollment trends for that state and selected years on the time slider.</li>",
                          "</ul></li>",
                          "<li><strong>Selecting States:</strong>",
                          "<ul>",
                          "<li><strong>Single State:</strong> Click on a state to select it. The state’s borders will be highlighted in blue. The spider plot and line graph will freeze to show data for the selected state. Hover over the dots in the spider chart to see enrollment ratios and over the line plot to see enrollment counts for specific years.</li>",
                          "<li><strong>Deselecting:</strong> To hover over another state, first deselect the current state by clicking it again. The blue border will disappear, allowing you to hover over any state to see the data.</li>",
                          "<li><strong>Multiple States:</strong> You can select multiple states to view combined data on all visuals. To see enrollment trends for all of Australia, select all states, and the graphs will display the aggregated data.</li>",
                          "</ul></li>",
                          "</ul>",
                          "<h5>Filters</h5>",
                          "<ul>",
                          "<li><strong>Time-slider Filter Feature:</strong> Adjusting the time slider will update the data for the selected filters on all graphs. This feature allows you to see how trends and patterns change over time for the selected states and filters.</li>",
                          "</ul>",
                          "<p><strong>Data Source: Australian Government, Department of Education: <a href='https://www.education.gov.au/higher-education-statistics/student-data' target='_blank'>https://www.education.gov.au/higher-education-statistics/student-data</a></strong></p>"
                        ))
                    )
             )
           )
           
    )
  )
)


# Define server logic
server <- function(input, output, session) {
  
  
  
  # Load shapefile for Australian states
  states <- ne_states(country = "Australia", returnclass = "sf") %>%
    filter(name %in% c("New South Wales", "Queensland", "Victoria", "Tasmania",
                       "South Australia", "Western Australia", "Northern Territory"))
  
  # Standardize state names to match the dataset
  states$name <- toupper(gsub(" ", "_", states$name))
  states$name <- gsub("_", " ", states$name)
  
  # Setting the dynamic instructions text
  output$dynamicInstructions <- renderUI({
    HTML(paste(
      "<style>
      ul { margin-left: 0; padding-left: 0; }
      li { margin-left: 20px; padding-left: 0; list-style-position: inside; font-size: 17px; }
      h4 { font-size: 24px; font-weight: bold; }
      h5 { font-size: 20px; font-weight: bold; }
      p { font-size: 18px; }
      </style>",
      "<h4>Dashboard Usage Instructions</h4>",
      "<p>For the best visibility, set your page zoom level to 67%.</p>",
      "<h5>Interactivity</h5>",
      "<p>This dashboard is interactive, allowing you to explore data visualizations for single or multiple states.</p>",
      "<h5>Additional Instructions</h5>",
      "<p>Detailed functionality instructions are available at the bottom of the dashboard layout. Understanding these will enhance your experience and comprehension of the data presented.</p>",
      "<h4>Understanding Domestic and Overseas Student Enrollment Distribution</h4>",
      "<h5>A Journey Through Enrollment Trends (2018-2022)</h5>",
      "<h5>2018: The Baseline Year</h5>",
      "<p>Start by focusing on the year 2018. Adjust the time slider located at the bottom left of the Australian map layout to show only 2018. Click on all the states of Australia shaded in green and white. The two graphs below the map will be updated accordingly.</p>",
      "<p>As you explore the spider plot beneath the map, you see a clear pattern emerge. Domestic students, represented in orange, gravitate towards fields like Education, Architecture, Health, and Agriculture. Overseas students, depicted in green, are significantly present in Engineering Technologies, Management & Commerce, and Information Technology. The colors blend and spread across the spider web, visually narrating the preferences and distribution of student enrollments.</p>",
      "<p>Take your cursor to the spider graph and hover on solid circles in line with Engineering Technologies, you discover that 54% of enrollments are domestic students, while the remaining 46% are overseas students. Now hovering on Management & Commerce, you see that the ratios are slightly in favor of overseas students, who make up 55.7% of the total, and the rest 44.3% is occupied by domestic students. Information Technology stands out with overseas students dominating at 63.3%, leaving domestic students at 36.7%.</p>",
      "<h5>2019: A Year of Growth</h5>",
      "<p>Moving the slider to include 2019, you notice a shift. The total enrollment count rises from 1.0165 million to 1.0493 million, summing up to over 2 million students when combined with the year 2018. The line graph on the right confirms this increasing trend. The spider plot, however, remains consistent with minor variations, echoing the student enrollment trends from the previous year.</p>",
      "<h5>2020: The Pandemic Impact</h5>",
      "<p>As you slide into 2020, the pace of growth slows. The enrollment count edges up slightly to 1.0518 million. Here, the spider plot tells a subtle story – a slight reduction in overseas enrollments contrasts with a steady rise in domestic enrollments. This subtle change hints at the impending disruptions.</p>",
      "<p>Hovering over the spider plot, you see the detailed impact. Domestic student enrollments continue to grow, while overseas enrollments show a slight decline. Despite these changes, the overall pattern remains the same as in 2018.</p>",
      "<h5>2021: The Crash</h5>",
      "<p>The year 2021 hits hard. Enrollment drops from 1.0518 million to 1.032 million. The global COVID-19 pandemic casts a long shadow over the educational landscape. Overseas student enrollments decline noticeably, while domestic enrollments manage a modest increase. The spider plot’s colors show these changes, reflecting the resilience and adaptability of domestic students amidst the pandemic.</p>",
      "<p>Examining the spider plot closely, you see the effects of the pandemic. Overseas enrollments drop significantly, but domestic enrollments show a slight uptick. The total enrollment from 2018 to 2021 reaches 4.15 million, with domestic students continuing to dominate fields like Agriculture, Health, Architecture, Engineering, and Education, while overseas students maintain a strong presence in IT, Management & Commerce.</p>",
      "<h5>2022: A Continued Decline</h5>",
      "<p>Finally, moving to 2022, the narrative becomes clear. The enrollment count dips further to 1.0061 million, the lowest since 2018. The spider plot shows a continued decrease in overseas enrollments and a slight increase in domestic enrollments. Despite the overall drop in numbers, the pattern remains unchanged, domestic students continue to dominate fields like Health, Architecture, Agriculture, and Education, while overseas students prefer IT. Engineering Management & Commerce fields display balanced ratios, with overseas students slightly favoring Management & Commerce, and domestic students leaning towards Engineering.</p>",
      "<p>Hovering over the spider plot in 2022, you see the clear trends. Domestic students still prefer fields like Health, while overseas students dominate in IT. Engineering and Management & Commerce show nearly balanced ratios, with a slight edge for domestic students in Engineering and for overseas students in Management & Commerce.</p>",
      "<h5>Conclusion</h5>",
      "<p>From 2018 to 2022, Australia's enrollment landscape weaves a complex story of growth, resilience, and adaptation. With a total of 5.16 million enrollments, the trends show a peak in 2020, followed by a decline influenced heavily by global events. Domestic students predominantly choose Agriculture, Health, Education, and Architecture, while overseas students are drawn to IT, Engineering, and Management & Commerce. Explore this dashboard to see these trends and interact with the data for deeper insights into how they have changed over the years.</p>",
      "<p><strong>Data Source: Australian Government, Department of Education: <a href='https://www.education.gov.au/higher-education-statistics/student-data' target='_blank'>https://www.education.gov.au/higher-education-statistics/student-data</a></strong></p>"
    ))

  })
  
  # Filter and summarize data based on year range
  filtered_data <- reactive({
    data %>%
      filter(YEAR >= input$year[1] & YEAR <= input$year[2])
  })
  
  # Calculate total enrollment count for each state
  total_enrollment_data <- reactive({
    filtered_data() %>%
      group_by(STATE) %>%
      summarise(
        ENROLLMENT_COUNT = sum(ENROLLMENT_COUNT),
        .groups = 'drop'
      )
  })
  
  # Calculate domestic enrollment count for each state
  domestic_enrollment_data <- reactive({
    filtered_data() %>%
      filter(CITIZENSHIP == "DOMESTIC") %>%
      group_by(STATE) %>%
      summarise(
        DOMESTIC_ENROLLMENT_COUNT = sum(ENROLLMENT_COUNT),
        .groups = 'drop'
      )
  })
  
  
  
  # Calculate overseas enrollment count for each state
  overseas_enrollment_data <- reactive({
    filtered_data() %>%
      filter(CITIZENSHIP == "OVERSEAS") %>%
      group_by(STATE) %>%
      summarise(
        OVERSEAS_ENROLLMENT_COUNT = sum(ENROLLMENT_COUNT),
        .groups = 'drop'
      )
  })
  
  # Merge all enrollment data
  merged_data <- reactive({
    total <- total_enrollment_data()
    domestic <- domestic_enrollment_data()
    overseas <- overseas_enrollment_data()
    
    merged <- total %>%
      left_join(domestic, by = "STATE") %>%
      left_join(overseas, by = "STATE") %>%
      mutate(
        DOMESTIC_ENROLLMENT_COUNT = ifelse(is.na(DOMESTIC_ENROLLMENT_COUNT), 0, DOMESTIC_ENROLLMENT_COUNT),
        OVERSEAS_ENROLLMENT_COUNT = ifelse(is.na(OVERSEAS_ENROLLMENT_COUNT), 0, OVERSEAS_ENROLLMENT_COUNT)
      )
    
    left_join(states, merged, by = c("name" = "STATE"))
  })
  
  # Choropleth Map
  output$map <- renderLeaflet({
    state_data <- merged_data()
    
    if (nrow(state_data) == 0) {
      return(NULL)
    }
    
    pal <- colorNumeric("Greens", domain = state_data$ENROLLMENT_COUNT, na.color = "transparent")
    
    leaflet(state_data) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~pal(ENROLLMENT_COUNT),
        fillOpacity = 0.7, color = "white", weight = 1,
        highlightOptions = highlightOptions(weight = 3, color = "blue", bringToFront = TRUE),
        label = ~paste(
          name, "<br>",
          "Total Enrollment = ", round(ENROLLMENT_COUNT, 2), "M", "<br>",
          "Domestic Enrollment = ", round(DOMESTIC_ENROLLMENT_COUNT, 2), "M", "<br>",
          "Overseas Enrollment = ", round(OVERSEAS_ENROLLMENT_COUNT, 2), "M"
        ) %>% lapply(htmltools::HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "2px 4px"),
          textsize = "10px",
          direction = "auto"
        ),
        layerId = ~name
      ) %>%
      addLegend("topright", pal = pal, values = state_data$ENROLLMENT_COUNT,
                title = "Enrollment Count (in Millions)", opacity = 0.7, 
                labFormat = labelFormat(suffix = "M"), bins = 7, 
                layerId = "legend")
  })
  
  observe({
    state_data <- merged_data()
    
    if (nrow(state_data) == 0) {
      return(NULL)
    }
    
    pal <- colorNumeric(palette = "YlGn", domain = state_data$ENROLLMENT_COUNT, na.color = "transparent")
    
    selected_states_list <- selected_states()
    
    leafletProxy("map", data = state_data) %>%
      clearShapes() %>%
      addPolygons(
        fillColor = ~pal(ENROLLMENT_COUNT),
        fillOpacity = 0.9, #Increase opacity to make color more intense
        color = ~ifelse(name %in% selected_states_list, "blue", "white"), 
        weight = ~ifelse(name %in% selected_states_list, 4, 2),  # Thicker border for selected states
        highlightOptions = highlightOptions(weight = 05, color = "blue", bringToFront = TRUE),
        label = ~paste(
          name, "<br>",
          "Total Enrollment = ", round(ENROLLMENT_COUNT, 2), "M", "<br>",
          "Domestic Enrollment = ", round(DOMESTIC_ENROLLMENT_COUNT, 2), "M", "<br>",
          "Overseas Enrollment = ", round(OVERSEAS_ENROLLMENT_COUNT, 2), "M"
        ) %>% lapply(htmltools::HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "2px 4px"),
          textsize = "10px",
          direction = "auto"
        ),
        layerId = ~name
      ) %>%
      addLegend("topright", pal = pal, values = state_data$ENROLLMENT_COUNT,
                title = "Enrollment Count (in Millions)", opacity = 0.7, 
                labFormat = labelFormat(suffix = "M"), bins = 7, 
                layerId = "legend")
  })
  
  
  
  # Reactive value to store the list of selected states
  selected_states <- reactiveVal(c())
  
  # Reactive value to store the currently hovered state
  hovered_state <- reactiveVal(NULL)
  
  
  # Observe click events on the map
  observeEvent(input$map_shape_click, {
    clicked_state <- input$map_shape_click$id
    if (!is.null(clicked_state)) {
      current_selection <- selected_states()
      if (clicked_state %in% current_selection) {
        # Deselect state
        selected_states(setdiff(current_selection, clicked_state))
      } else {
        # Select state
        selected_states(c(current_selection, clicked_state))
      }
    }
  })
  
  # Observe hover events on the map
  observeEvent(input$map_shape_mouseover, {
    hovered_state(input$map_shape_mouseover$id)
  })
  
  observeEvent(input$map_shape_mouseout, {
    hovered_state(NULL)
  })
  # Calculate total enrollment count based on filters
  total_enrollment_count <- reactive({
    states_to_consider <- c(selected_states(), hovered_state())
    states_to_consider <- states_to_consider[states_to_consider != ""]
    if (length(states_to_consider) == 0) {
      return(sum(filtered_data()$ENROLLMENT_COUNT))
    } else {
      return(sum(filtered_data() %>% filter(STATE %in% states_to_consider) %>% pull(ENROLLMENT_COUNT)))
    }
  })
  
  # Display the total enrollment count
  output$totalEnrollmentCount <- renderUI({
    HTML(paste(
      "<div style='background-color: #e9ecef; border: 1px solid #ddd; border-radius: 10px; padding: 10px; margin-top: 10px;'>",
      "<strong>Total Enrollment Count for selected filters:</strong> ",
      round(total_enrollment_count(), 2), "M",
      "</div>"
    ))
  })
  
  
  # Spider plot data based on selected or hovered state
  spider_plot_data <- reactive({
    states_to_plot <- selected_states()
    if (length(states_to_plot) == 0) {
      states_to_plot <- hovered_state()
    }
    if (is.null(states_to_plot) || length(states_to_plot) == 0) {
      return(data.frame(
        EDUCATION_FIELD = c("Field1", "Field2", "Field3"),
        DOMESTIC_RATIO = c(0, 0, 0),
        OVERSEAS_RATIO = c(0, 0, 0)
      ))
    }
    
    data_filtered <- filtered_data() %>%
      filter(STATE %in% states_to_plot) %>%
      group_by(EDUCATION_FIELD, CITIZENSHIP) %>%
      summarise(
        ENROLLMENT_COUNT = sum(ENROLLMENT_COUNT),
        .groups = 'drop'
      ) %>%
      pivot_wider(names_from = CITIZENSHIP, values_from = ENROLLMENT_COUNT, values_fill = list(ENROLLMENT_COUNT = 0))
    
    data_filtered %>%
      mutate(
        TOTAL = DOMESTIC + OVERSEAS,
        DOMESTIC_RATIO = DOMESTIC / TOTAL,
        OVERSEAS_RATIO = OVERSEAS / TOTAL
      )
  })
  
  # Reactive value to track the display state of percentages
  display_percentages <- reactiveVal(FALSE)
  
  # Toggle the display state when the button is clicked
  observeEvent(input$togglePercentages, {
    display_percentages(!display_percentages())
    updateActionButton(session, "togglePercentages", 
                       label = ifelse(display_percentages(), "Hide Percentage", "Display Percentage"))
  })
  
  output$spiderPlot <- renderPlotly({
    plot_data <- spider_plot_data()
    if (is.null(plot_data)) return(NULL)
    
    selected_states_list <- selected_states()
    all_states <- unique(data$STATE)
    
    if (length(selected_states_list) > 6) {
      state <- "Australia"
      caption <- "STUDENT ENROLLMENT RATIO IN RESPECTIVE EDUCATION FIELDS IN AUSTRALIA"
    } else if (length(selected_states_list) > 0) {
      state <- paste(selected_states_list, collapse = ", ")
      caption <- paste(state, "STUDENT ENROLLMENT RATIO IN RESPECTIVE EDUCATION FIELDS")
    } else {
      hovered <- hovered_state()
      if (is.null(hovered) || length(hovered) == 0) {
        caption <- "STUDENT ENROLLMENT RATIO IN RESPECTIVE EDUCATION FIELDS"
      } else {
        caption <- paste(hovered, "STUDENT ENROLLMENT RATIO IN RESPECTIVE EDUCATION FIELDS")
      }
    }
    
    # Adjust the font size or wrap text for the caption
    caption <- strwrap(caption, width = 80)
    caption <- paste(caption, collapse = "<br>")
    
    plot_data <- plot_data %>%
      mutate(
        DOMESTIC_RATIO = round(DOMESTIC_RATIO * 100, 1),
        OVERSEAS_RATIO = round(OVERSEAS_RATIO * 100, 1),
        hover_text = paste("<b>", EDUCATION_FIELD, "</b><br><b>Domestic Enrollment: ", DOMESTIC_RATIO, "%</b><br><b>Overseas Enrollment: ", OVERSEAS_RATIO, "%</b>")
      )
    
    max_value <- max(plot_data %>% select(DOMESTIC_RATIO, OVERSEAS_RATIO) %>% unlist(), na.rm = TRUE)
    
    p <- plot_ly(type = 'scatterpolar', mode = 'markers+lines', fill = 'toself') %>%
      add_trace(r = plot_data$DOMESTIC_RATIO, theta = plot_data$EDUCATION_FIELD, name = 'Domestic',
                fillcolor = 'rgba(255, 165, 0, 0.3)', line = list(color = 'orange', width = 4),
                marker = list(size = 14, color = 'orange'), text = plot_data$hover_text, hoverinfo = 'text',
                hoverlabel = list(bgcolor = '#a0ced9', bordercolor = 'black', font = list(size = 14, color = 'black', family = 'Arial', weight = 'bold'))) %>%
      add_trace(r = plot_data$OVERSEAS_RATIO, theta = plot_data$EDUCATION_FIELD, name = 'Overseas',
                fillcolor = 'rgba(0, 128, 0, 0.3)', line = list(color = 'green', width = 4),
                marker = list(size = 14, color = 'green'), text = plot_data$hover_text, hoverinfo = 'text',
                hoverlabel = list(bgcolor = '#a0ced9', bordercolor = 'black', font = list(size = 14, color = 'black', family = 'Arial', weight = 'bold')))
    
    if (display_percentages()) {
      p <- p %>%
        add_trace(r = plot_data$DOMESTIC_RATIO, theta = plot_data$EDUCATION_FIELD, mode = 'text', text = paste(plot_data$DOMESTIC_RATIO, "%"),
                  textfont = list(color = 'black', size = 18, outlinewidth = 3, outlinecolor = 'black'), hoverinfo = 'none', name = 'Domestic %') %>%
        add_trace(r = plot_data$OVERSEAS_RATIO, theta = plot_data$EDUCATION_FIELD, mode = 'text', text = paste(plot_data$OVERSEAS_RATIO, "%"),
                  textfont = list(color = 'black', size = 18, outlinewidth = 3, outlinecolor = 'black'), hoverinfo = 'none', name = 'Overseas %')
    }
    
    p <- p %>%
      layout(
        polar = list(
          radialaxis = list(visible = TRUE, range = c(0, max_value), tickfont = list(size = 12, family = "bold"),
                            tickvals = seq(0, max_value, by = 10), ticktext = paste0(seq(0, max_value, by  = 10), '%')),
          angularaxis = list(tickfont = list(size = 12, family = "bold"))
        ),
        annotations = list(
          x = 0.5, y = -0.25, 
          text = caption, 
          showarrow = FALSE,
          xref = 'paper', yref = 'paper',
          font = list(size = 13, family = "bold"),
          align = 'center'
        ),
        margin = list(b = 130),
        showlegend = TRUE,
        legend = list(font = list(size = 12, family = "bold"))
      )
    
    p
  })
  
  
  
  # Trend plot data based on selected or hovered state
  trend_plot_data <- reactive({
    states_to_plot <- selected_states()
    if (length(states_to_plot) == 0) {
      states_to_plot <- hovered_state()
    }
    if (is.null(states_to_plot) || length(states_to_plot) == 0) {
      return(data.frame(
        YEAR = c(2018, 2019, 2020, 2021, 2022),
        ENROLLMENT_COUNT = c(0, 0, 0, 0, 0)
      ))
    }
    
    filtered_data() %>%
      filter(STATE %in% states_to_plot) %>%
      group_by(YEAR) %>%
      summarise(
        ENROLLMENT_COUNT = sum(ENROLLMENT_COUNT),
        .groups = 'drop'
      )
  })
  
  output$trendPlot <- renderPlotly({
    plot_data <- trend_plot_data()
    if (is.null(plot_data)) return(NULL)
    
    min_value <- min(plot_data$ENROLLMENT_COUNT, na.rm = TRUE)
    max_value <- max(plot_data$ENROLLMENT_COUNT, na.rm = TRUE)
    y_margin <- (max_value - min_value) * 0.4  # Adjust the margin as needed
    y_start <- min_value - y_margin  # Start y-axis slightly below the min value
    y_end <- max_value + y_margin  # End y-axis slightly above the max value
    selected_states_list <- selected_states()
    all_states <- unique(data$STATE)
    
    if (length(selected_states_list) > 6) {
      title <- "ENROLLMENT TRENDS IN AUSTRALIA"
    } else if (length(selected_states_list) > 0) {
      title <- paste("ENROLLMENT TRENDS IN ", paste(selected_states_list, collapse = ", "))
    } else {
      hovered <- hovered_state()
      if (is.null(hovered) || length(hovered) == 0) {
        title <- "ENROLLMENT TRENDS"
      } else {
        title <- paste("ENROLLMENT TRENDS", hovered)
      }
    }
    
    # Adjust the font size or wrap text for the title
    title <- strwrap(title, width = 60)
    title <- paste(title, collapse = "<br>")
    
    plot_ly(plot_data, x = ~YEAR, y = ~ENROLLMENT_COUNT, type = 'scatter', mode = 'lines+markers+text',
            line = list(color = 'blue', width = 2),
            marker = list(size = 8, color = 'blue'),
            text = ~paste0(round(ENROLLMENT_COUNT, 4), "M"),  # Formatting labels to 4 decimal places
            textposition = "top middle",  # Positioning the text
            textfont = list(size = 18, color = 'black', family = "bold"),  # Adjusting the font size
            hoverinfo = 'text+name') %>%  # Display the labels with 'text'
      layout(
        title = list(text = title, font = list(size = 21), y = 0.95, x = 0.5, xanchor = 'center'),
        xaxis = list(
          title = "Year", 
          type = 'category', 
          categoryorder = "array", 
          categoryarray = c(2018, 2019, 2020, 2021, 2022),  # Specify tick values
          showgrid = TRUE,  # Show grid lines
          gridcolor = 'lightgray',  # Color of the grid lines
          gridwidth = 1  # Width of the grid lines
        ),
        yaxis = list(
          title = "Enrollment Count (in Millions)", 
          range = c(y_start, y_end),
          showgrid = TRUE,  # Show grid lines
          gridcolor = 'lightgray',  # Color of the grid lines
          gridwidth = 1  # Width of the grid lines
        ),
        plot_bgcolor = '#FFFFF0',  # Background color of the plot area
        hoverlabel = list(font = list(size = 24, family = "bold")),  # Increase hover label size
        showlegend = FALSE
      )
  })
  
  
}

shinyApp(ui, server)

