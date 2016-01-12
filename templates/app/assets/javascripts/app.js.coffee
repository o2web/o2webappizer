class App extends CMS
  @start: =>
    super
    @ready =>
      NProgress.configure showSpinner: false
      $('img').lazyload()

window.App = App
