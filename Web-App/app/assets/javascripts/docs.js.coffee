jQuery ->
  $("#doc-sidebar").affix (
    offset: {
      top: 245
    }
  )
  navHeight = $('.navbar').outerHeight(true) + 10

  body   = $(document.body)
  body.scrollspy(
  	target: '#leftCol',
  	offset: navHeight
  )