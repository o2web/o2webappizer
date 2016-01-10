class App extends CMS
  @start: =>
    super
    NProgress.configure showSpinner: false
    $('img').lazyload()

window.App = App
