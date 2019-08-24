from flask import Flask, render_template, request, jsonify
from flask_restful import reqparse, abort, Api, Resource
from flask_socketio import SocketIO, emit, Namespace, send

from flask_ngrok import run_with_ngrok

app = Flask(__name__, static_folder="static", template_folder="static")
api = Api(app)
app.config["SECRET_KEY"] = "secret!"
socketio = SocketIO(app)

websocket_namespace = "/test"


class State:
    def __init__(self):
        self.state = {}

    def get_state(self):
        return self.state

    def set_state(self, state):
        self.state = state


state = State()


@app.route("/")
def index():
    return render_template("index.html")


@socketio.on("connect", namespace=websocket_namespace)
def test_connect():
    emit("my_response", {"data": "Connected!"})


@socketio.on("my_event", namespace=websocket_namespace)
def test_message(message):
    emit("my_response", message)


@socketio.on("updated_state", namespace=websocket_namespace)
def test_message(message):
    state.set_state(message)
    emit(
        "client_updated_state",
        {"action": message},
        broadcast=True,
        namespace=websocket_namespace,
    )


@socketio.on("disconnect", namespace=websocket_namespace)
def test_disconnect():
    print("Client disconnected")


class Actions(Resource):
    def get(self):
        return state.get_state()


class PostAction(Resource):
    def post(self):
        json_data = request.get_json(force=True)
        action = json_data.get("action")
        if action in [1, 2, 3, 4]:
            emit(
                "my_response",
                {"action": action},
                broadcast=True,
                namespace=websocket_namespace,
            )
            return 201

        return 400


class GetState(Resource):
    def get(self):
        return state.get_state()


api.add_resource(PostAction, "/action")
api.add_resource(GetState, "/state")

if __name__ == "__main__":
    socketio.run(app, debug=True)

