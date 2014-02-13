$(window).load ->
  $(".main").onepage_scroll
    sectionContainer: "section"
    responsiveFallback: 600
    easing: "ease"
    animationTime: 1000
    pagination: false
    updateURL: true
    beforeMove: (index) ->
    afterMove: (index) ->
      loop: false
      keyboard: true
      responsiveFallback: false
  return

$(window).load ->
  $(".register_button").on "click", ->
    $("#login").hide()
    $("#homepage_options").removeClass "visible-lg"
    $("#homepage_options").hide()
    $("#register").show()
    return

  $("#user_city_id").gentleSelect() # apply gentleSelect with default options
  $("#user_university_id").gentleSelect() # apply gentleSelect with default options
  $("#user_graduation_year").gentleSelect() # apply gentleSelect with default options
  $("#user_professional_field_id").gentleSelect() # apply gentleSelect with default options

  $("#flexiselDemo1").flexisel
    enableResponsiveBreakpoints: true
    visibleItems: 3

    responsiveBreakpoints:
      portrait:
        changePoint: 480
        visibleItems: 1

      landscape:
        changePoint: 640
        visibleItems: 2

      tablet:
        changePoint: 768
        visibleItems: 3

  $("#flexiselDemo2").flexisel
    enableResponsiveBreakpoints: true
    visibleItems: 3

    responsiveBreakpoints:
      portrait:
        changePoint: 480
        visibleItems: 1

      landscape:
        changePoint: 640
        visibleItems: 2

      tablet:
        changePoint: 768
        visibleItems: 3

  return

