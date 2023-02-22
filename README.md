# Ambrose Chat

## What is Ambrose Chat?
The Ambrose Chat is a chat widget application that seamlessly integrates with your website to provide to your website a chat experience. This built using vanilla javascript and phoenix framework and provides real-time conversations for your users.

## Why I choose Phoenix Framework?
The Phoenix Framework is a powerful web framework built on top of the Elixir programming language, designed to enable the development of highly concurrent and fault-tolerant applications. One of the main reasons why I chose to use Phoenix for the project is its ability to handle large volumes of traffic with ease. With its built-in support for WebSockets and real-time messaging, Phoenix allows for efficient communication between the server and client, enabling seamless user experiences.

In addition, the Phoenix Framework promotes a functional programming style, making it easier to write clear, maintainable, and testable code. The framework's use of the Actor Model and OTP (Open Telecom Platform) further enhances its ability to handle concurrency and fault tolerance, ensuring that your application remains responsive and resilient under heavy loads.

## What's the trade-off of Phoenix Framework between Socket.io?
In terms of performance, Phoenix is generally regarded as more performant than Socket.io, thanks to its use of the BEAM virtual machine and the OTP (Open Telecom Platform) library, which allow for efficient handling of concurrency and fault tolerance. This can be particularly advantageous for applications that need to handle a large number of users and real-time interactions.
Another important consideration is the learning curve. Phoenix can have a steeper learning curve due to its use of functional programming concepts with Elixir/Erlang and its unique language syntax. Socket.io, on the other hand, uses a more conventional JavaScript syntax, making it easier for developers with JavaScript experience to get started quickly.
So basically for scaling Phoenix will be a better choice. But in the beginning, Socket.io can be a good choice for starting a chat real-time conversation. I prefer to use Phoenix Framework by first because I want to scale Ambrose Chat as faster as I can with a low cost of infrastructure.

## Important concepts:

### How Channels in Phoenix works?
Phoenix channels are used for real-time communication between a server and connected clients over WebSockets. Channels enable bidirectional communication, which means both the server and the client can send and receive messages. Channels are designed to work seamlessly with the Phoenix framework and can be used in combination with Phoenix's existing features like controllers and views.

Channels consist of three primary components:

1 - The server-side channel module.

2 - The client-side JavaScript.

3 - The message payload: This is the actual data being sent between the client and the server.

Channels also have several useful features, including:

Presence tracking: This allows you to keep track of which clients are currently connected to a channel.
Message broadcasting: This allows you to broadcast messages to all connected clients or to specific clients.
Error handling: Channels provide several error-handling mechanisms to help you handle and recover from errors.
### What`s Phoenix Live View?
Phoenix LiveView is a library for the Phoenix web framework that allows developers to build interactive, real-time web applications without writing JavaScript. It allows you to create server-rendered HTML templates that update automatically as the data in your application changes, making it easy to build complex user interfaces and keep them in sync with the server.

LiveView works by using the Phoenix channels, which establish a persistent connection between the client and server over a WebSocket, allowing the server to push updates to the client in real-time. LiveView templates are rendered on the server and sent to the client as HTML, along with the necessary JavaScript and channel code to establish the connection.

LiveView templates use a simple and familiar syntax that looks and feels like standard Elixir/Phoenix templates, and they can use any Elixir code, including database queries and other back-end operations. This makes it easy to create complex interfaces without having to write complex JavaScript.

## About Infrastructure:

### How to scale it?
There's a famous benchmarking of Phoenix Framework in this [link](https://phoenixframework.org/blog/the-road-to-2-million-websocket-connections)

### Important Commands:

#### To create new phoenix channel:
```
mix phx.gen.channel Room
```

#### The command that I`ve generated the Dockerfile:
```
mix phx.gen.release --docker
```
#### To run the project without Dockerfile:
```
mix deps.get
mix phx.server
```

## The next steps:
- [ ] Render as iframe for the website can use as widget
- [ ] Dockerize the project
- [ ] Custom Nickname
- [ ] Modeling Database
- [ ] Security Concerns
- [ ] Chat Authentication
- [ ] Custom Profile Picture
- [ ] CMS Pannel for Managing The Chat Rooms