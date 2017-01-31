define ['leaflet'], (L) ->
  CacheBtnControl = L.Control.extend
    initialize: (@offlineLayer)->

    onAdd: (map) ->
      controls = L.DomUtil.create('div', 'control-button', this._container)

      @cacheButton = L.DomUtil.create('input', 'cache-button', controls)
      @cacheButton.setAttribute('type', "button")
      @cacheButton.setAttribute('id', "Btn1")
      @cacheButton.setAttribute('value', "Cache")

      L.DomEvent.addListener(@cacheButton, 'click', this.onCacheClick, this)
      L.DomEvent.disableClickPropagation(@cacheButton)

      @cacheTo17Button = L.DomUtil.create('input', 'cache-up-to-button', controls)
      @cacheTo17Button.setAttribute('type', "button")
      @cacheTo17Button.setAttribute('id', "Btn1")
      @cacheTo17Button.setAttribute('value', "Cache up to 17")

      L.DomEvent.addListener(@cacheTo17Button, 'click', this.onCacheUpToClick, this)
      L.DomEvent.disableClickPropagation(@cacheTo17Button)

      @clearButton = L.DomUtil.create('input', 'offlinemap-controls-clear-button', controls)
      @clearButton.setAttribute('type', "button")
      @clearButton.setAttribute('id', "clearBtn")
      @clearButton.setAttribute('value', "Clear DB")

      L.DomEvent.addListener(@clearButton, 'click', this.onClearClick, this)
      L.DomEvent.disableClickPropagation(@clearButton)

      controls

    onClearClick: () ->
      @_setBusyState()

      @offlineLayer.clearTiles(
        () =>
          @_setIdleState()
        ,
        (error) =>
          @_setIdleState()
      )

    onCacheClick: () ->
      # Might be a good idea to put a limit on the number of tiles that can would be saved
      # calculateNbTiles includes potentially already saved tiles.
      nbTiles = @offlineLayer.calculateNbTiles();
      if nbTiles == -1
        return
      if(nbTiles < 10000)
        console.log("Will be saving: " + nbTiles + " tiles");

        @_setBusyState()

        @offlineLayer.saveTiles(17,
          () =>
            null
          ,
          () =>
            @_setIdleState()
          ,
          (error) =>
            console.log(error)
            @_setIdleState()
        )
      else
        alert("You are trying to save " + nbTiles + " tiles. There is currently a limit of 10,000 tiles.")


    onCacheUpToClick: () ->
      nbTiles = @offlineLayer.calculateNbTiles(17)
      if nbTiles < 10000
        console.log("Will be saving: " + nbTiles + " tiles")

        @_setBusyState()

        @offlineLayer.saveTiles(17,
          () =>
            null
          ,
          () =>
            @_setIdleState()
          ,
          (error) =>
            console.log(error)
            @_setIdleState()
        )
      else
        alert("You are trying to save " + nbTiles + " tiles. There is currently a limit of 10,000 tiles.")

    _setBusyState: () ->
      @cacheTo17Button.setAttribute('disabled', true)
      @cacheButton.setAttribute('disabled', true)
      @clearButton.setAttribute('disabled', true)

    _setIdleState: () ->
      @cacheTo17Button.removeAttribute('disabled')
      @cacheButton.removeAttribute('disabled')
      @clearButton.removeAttribute('disabled')
