#OpenTok javascript API wrappers

class StreamManager
  session: null

  constructor: (sessionId, apiKey, token) ->

    @session = TB.initSession(sessionId)     
    @session.addEventListener('sessionConnected', @sessionConnectedHandler)
    @session.addEventListener('streamCreated', @streamCreatedHandler)   
    @session.connect(apiKey, token)
 

  sessionConnectedHandler: (event) =>
    publisher = @session.publish('myPublisherDiv', { width: 400, height: 300 })
    # Subscribe to streams that were in the session when we connected
    @subscribeToStreams(event.streams)

  streamCreatedHandler: (event) =>
    # Subscribe to any new streams that are created
    @subscribeToStreams(event.streams)
  
   
  subscribeToStreams: (streams) ->
    for stream in streams
      # Check that connectionId on the stream to make sure we don't subscribe to ourself
      if (stream.connection.connectionId != @session.connection.connectionId)
        # Create the div to put the subscriber element in to
        div = document.createElement('div');
        div.setAttribute('id', 'stream' + stream.streamId)
        document.body.appendChild(div);
         
        # Subscribe to the stream
        @session.subscribe(stream, div.id, { width: 800, height: 600 });


class VideoPlayer
  id: null
  token: null
  player: null
  recorderManager: null

  constructor: (id, api_key, token) ->
    @id = id
    @token = token
    @recorderManager = TB.initRecorderManager(api_key);
    @playerId = '#playerContainer' + id


  loadArchiveInPlayer: (archiveId) ->
    $(@playerId).show()
    if (!@player)
      playerDiv = document.createElement('div');
      playerDiv.setAttribute('id', 'playerElement');
      document.getElementById('playerContainer' + @id).appendChild(playerDiv);
      @player = @recorderManager.displayPlayer(archiveId, @token, playerDiv.id);
    else
      @player.loadArchive(archiveId);


  closePlayer: ->
    @recorderManager.removePlayer(@player)
    @player = null
    $(@playerId).hide()

class VideoRecord extends VideoPlayer
  recorder: null
  recImgData: null

  constructor: (id, api_key, token) ->
    super(id, api_key, token)
    @createRecorder()
    @recorderId = '#recorderContainer' + id

  createRecorder: ->
    recDiv = document.createElement('div');
    recDiv.setAttribute('id', 'recorderElement');
    document.getElementById('recorderContainer' + @id).appendChild(recDiv);
    @recorder = @recorderManager.displayRecorder(@token, recDiv.id);
    @recorder.addEventListener('recordingStarted', @recStartedHandler);
    @recorder.addEventListener('archiveSaved', @archiveSavedHandler);
    

  switchToPlayer: (archiveId) ->
    $(@recorderId).hide()
    @loadArchiveInPlayer(archiveId)

  switchToRecorder: ->
    $(@playerId).hide()
    $(@recorderId).show()

    # TODO: discard the saved video from the server

  getImg: (imgData) ->
    img = document.createElement('img');
    img.setAttribute('src', 'data:image/png;base64,' + imgData);
    return img

  # -------------------------------------
  #   OPENTOK EVENT HANDLERS
  # --------------------------------------

  recStartedHandler: (event) =>
    @recImgData = @recorder.getImgData();

  archiveSavedHandler: (event) =>
    # fill the hidden input tag with the archive id
    archiveId = event.archives[0].archiveId
    $('#videoArchive' + @id).val(archiveId)

    @switchToPlayer(archiveId)



# hoist the classes into the global namespace to reference it outside
window.VideoPlayer = VideoPlayer
window.VideoRecord = VideoRecord
window.StreamManager = StreamManager



#  Un-comment either of the following to set automatic logging and exception handling.
# // See the exceptionHandler() method below.
# // TB.setLogLevel(TB.DEBUG);
# // TB.addEventListener('exception', exceptionHandler);
# 
# If you un-comment the call to TB.addEventListener('exception', exceptionHandler) above, OpenTok calls the
# exceptionHandler() method when exception events occur. You can modify this method to further process exception events.
# If you un-comment the call to TB.setLogLevel(), above, OpenTok automatically displays exception event messages.
# */
# function exceptionHandler(event) {
#   alert('Exception: ' + event.code + '::' + event.message);
# }