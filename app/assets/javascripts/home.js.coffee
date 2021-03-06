$ ->
  $(".main").onepage_scroll
    sectionContainer: "section"
    responsiveFallback: 600
    easing: "cubic-bezier(0.175, 0.885, 0.420, 1.310)"
    animationTime: 1000
    pagination: true
    updateURL: true
    beforeMove: (index) ->
    afterMove: (index) ->
    loop: false
    keyboard: true
    responsiveFallback: false

  $(".register_button").click ->
    $(".main").moveUp();
    $(".main").moveUp();
    $(".main").moveUp();

  $(".for_students").click ->
    $(".main").moveDown();

  $(".for_alumni").click ->
    $(".main").moveDown();
    $(".main").moveDown();

  $(".about_us").click ->
    $(".main").moveDown();
    $(".main").moveDown();
    $(".main").moveDown();

  $(".register_button").on "click", ->
    $(document).unbind('mousewheel DOMMouseScroll') #unbind onepage_scroll
    $("#login").hide()
    $("#homepage_options").removeClass "visible-lg"
    $("#homepage_options").hide()
    $("#student_registration").fadeIn()
    return

  $(".register_as_alumni").on "click", ->
    $('#student_registration').hide();
    $('#alumi_registration').fadeIn();

  $(".register_as_student").on "click", ->
    $('#alumi_registration').hide();
    $('#student_registration').fadeIn();

  $("#student_registration #user_city_id").gentleSelect() # apply gentleSelect with default options
  $("#student_registration #user_university_id").gentleSelect() # apply gentleSelect with default options
  $("#student_registration #user_graduation_year").gentleSelect() # apply gentleSelect with default options
  $("#student_registration #user_professional_field_id").gentleSelect() # apply gentleSelect with default options
  $("#alumi_registration #user_city_id").gentleSelect() # apply gentleSelect with default options
  $("#alumi_registration #user_university_id").gentleSelect() # apply gentleSelect with default options
  $("#alumi_registration #user_graduation_year").gentleSelect() # apply gentleSelect with default options
  $("#alumi_registration #user_professional_field_id").gentleSelect() # apply gentleSelect with default options

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
