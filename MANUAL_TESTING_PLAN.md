# Manual Testing Plan: Chat Widget Functionality

**Objective:** To verify the core functionality of the chat widget, including loading states, single-user and multi-user interactions, presence, nickname changes, and message exchange.

**Prerequisites:**
*   A modern web browser (e.g., Chrome, Firefox) with developer tools.
*   The Phoenix application code available.
*   Docker installed and running (if testing with Docker).

---

**1. Setup**

*   **1.1. Running the Application (Choose one method):**
    *   **Method A: Using `mix phx.server` (Local Development)**
        1.  Navigate to the `chat_app` directory in your terminal: `cd /path/to/chat_app`
        2.  Ensure dependencies are installed: `mix deps.get`
        3.  Ensure assets are built: `mix assets.deploy` (or equivalent for your project, e.g., `npm run deploy --prefix ./assets`).
        4.  Start the Phoenix server: `mix phx.server`
        5.  The application should now be running, typically at `http://localhost:4000`.
    *   **Method B: Using Docker (If Docker setup is complete and preferred)**
        1.  Navigate to the `chat_app` directory in your terminal: `cd /path/to/chat_app`
        2.  Ensure a Docker image named `chat_app:latest` has been built successfully.
        3.  Generate a `SECRET_KEY_BASE` if you don't have one: `mix phx.gen.secret` (copy the output).
        4.  Run the Docker container:
            ```bash
            sudo docker run --rm -e SECRET_KEY_BASE="YOUR_COPIED_SECRET_KEY_BASE" -p 4000:4000 chat_app:latest
            ```
        5.  The application should now be running in the Docker container, accessible at `http://localhost:4000`.

*   **1.2. Accessing the Chat Widget:**
    1.  Once the application is running, open a web browser.
    2.  Navigate to the chat widget URL: `http://localhost:4000/widget/chat`

---

**2. Testing the Loading State**

*   **Test Case 2.1: Initial Load**
    1.  Open the chat widget URL (`http://localhost:4000/widget/chat`) in your browser.
    2.  **Expected Result:**
        *   The "Connecting to chat..." message and the spinner animation are immediately visible.
        *   The main chat interface (including nickname input, chat messages area, message input field, and online users list) is *not* visible.

*   **Test Case 2.2: Successful Connection**
    1.  Observe the widget loading (as per Test Case 2.1).
    2.  After a brief moment (normal connection time for your local/network environment).
    3.  **Expected Result:**
        *   The loading indicator (both the "Connecting to chat..." message and the spinner) disappears.
        *   The main chat interface becomes visible and operational.
        *   A join message (e.g., "Joined as GuestXYZ") appears in the chat.

*   **Test Case 2.3: Connection Error (Simulated or Induced)**
    *   **Method A: Simulate by Stopping Server (if practical):**
        1.  Open the chat widget URL. Let the HTML and initial JavaScript load.
        2.  Quickly (before the WebSocket connection fully establishes, usually within 1-2 seconds), stop the Phoenix server (Ctrl+C twice in the terminal for `mix phx.server`, or `sudo docker stop <container_id>` if using Docker).
        3.  Alternatively, use browser developer tools:
            *   Open Developer Tools (usually F12).
            *   Go to the "Network" tab.
            *   Find the WebSocket request (usually to `/socket/websocket`).
            *   Right-click and "Block request URL" or similar, then refresh the widget page.
    *   **Method B: Code Review (if direct simulation is difficult):**
        1.  Review the JavaScript code in `chat.html.heex` for the `channel.join().receive("error", resp => { ... })` block.
    *   **Expected Results (for both methods, where applicable):**
        *   The loading indicator (the container `div#loading-indicator`) remains visible.
        *   The text within the loading indicator updates from "Connecting to chat..." to an error message (e.g., "Failed to connect: ... Please try refreshing.").
        *   The spinner animation within the loading indicator stops or is hidden.
        *   The main chat interface (`div#chat-interface`) remains hidden or becomes hidden if it was briefly shown.

*   **Test Case 2.4: Fast Connection Observation**
    1.  Load the chat widget URL normally.
    2.  **Observation:** If the connection to the server is very fast (common on localhost), the loading state might only flash for a very brief period.
    3.  **Action (Optional, for better observation):**
        *   Open browser developer tools.
        *   Go to the "Network" tab.
        *   Find the network throttling options (often a dropdown labeled "No throttling" or similar).
        *   Select a slower speed (e.g., "Slow 3G" or a custom slower profile).
        *   Refresh the chat widget page.
    4.  **Expected Result:** With a throttled connection, the loading indicator ("Connecting to chat..." and spinner) should be visible for a longer, more observable duration before the main chat interface appears (on successful connection).

---

**3. Basic Chat (Single User)**

*   **Test Case 3.1: Widget Initial State (Post-Loading)**
    1.  After the widget loads successfully (loading indicator gone, chat interface visible).
    2.  **Expected Result:**
        *   The nickname input field should be pre-filled with a default guest nickname (e.g., "GuestXYZ").
        *   The chat messages area should show an initial join message (e.g., "Joined as GuestXYZ").
        *   The "Online Users" list should display your default nickname.
        *   The message input field should be empty and enabled.

*   **Test Case 3.2: Sending a Message**
    1.  In the message input field, type a message (e.g., "Hello world!").
    2.  Click the "Send" button.
    3.  **Expected Result:**
        *   The message ("Hello world!") should appear in the chat messages area, prefixed with your current nickname (e.g., "GuestXYZ: Hello world!").
        *   Your own messages should have a distinct background color.
        *   The message input field should be cleared after sending.
        *   The chat messages area should scroll to the bottom if necessary.

*   **Test Case 3.3: Changing Nickname**
    1.  In the nickname input field, type a new nickname (e.g., "Tester1").
    2.  Click the "Set Nickname" button.
    3.  **Expected Result:**
        *   An informational message should appear in the chat (e.g., "GuestXYZ is now known as Tester1").
        *   The "Online Users" list should update to show "Tester1".
        *   The nickname input field should now display "Tester1".
    4.  Send another message (e.g., "Testing with new nickname").
    5.  **Expected Result:**
        *   The new message should appear in the chat messages area, prefixed with "Tester1".

---

**4. Multi-User Interaction (Requires 2+ browser windows/tabs)**

*   **Setup:** Open the chat widget URL (`http://localhost:4000/widget/chat`) in two separate browser windows or tabs. Let's call them "User A" and "User B". Ensure both have completed the loading phase.

*   **Test Case 4.1: Joining**
    1.  **User A:** Observe the widget. (Should have a default nickname, e.g., "GuestA")
    2.  **User B:** Open the widget. (Should have a different default nickname, e.g., "GuestB")
    3.  **Expected Results:**
        *   **User A's View:**
            *   Initially, User A sees "GuestA" in their online list.
            *   After User B joins, User A should see both "GuestA" and "GuestB" in the online list.
            *   User A should see a join message for User B (e.g., "GuestB has entered the room.").
        *   **User B's View:**
            *   User B sees both "GuestA" and "GuestB" in their online list.
            *   User B should see a join message for themselves (e.g., "Joined as GuestB").

*   **Test Case 4.2: Messaging**
    1.  **User A:** Set nickname to "Alice".
    2.  **User B:** Set nickname to "Bob". (Verify nickname change messages appear for both users, and user lists update).
    3.  **User A:** Send a message: "Hi Bob!"
    4.  **Expected Result (User B's View):** User B sees "Alice: Hi Bob!".
    5.  **User B:** Send a message: "Hello Alice!"
    6.  **Expected Result (User A's View):** User A sees "Bob: Hello Alice!".

*   **Test Case 4.3: Nickname Changes**
    1.  **User A ("Alice"):** Change nickname to "Alicia".
    2.  **Expected Results:**
        *   **User A's View:** Sees a confirmation message (e.g., "Alice is now known as Alicia"). User list shows "Alicia".
        *   **User B's View:** Sees the message "Alice is now known as Alicia". User list updates to show "Alicia".
    3.  **User A ("Alicia"):** Send a message.
    4.  **Expected Result (User B's View):** Message appears from "Alicia".

*   **Test Case 4.4: Leaving**
    1.  **User A ("Alicia"):** Close their browser tab/window.
    2.  **Expected Result (User B's View):** "Alicia" disappears from the "Online Users" list.

---

**5. Edge Cases/Other**

*   **Test Case 5.1: Sending Empty Messages**
    1.  Attempt to send an empty message.
    2.  **Expected Result:** No message sent.

*   **Test Case 5.2: Setting Empty Nickname**
    1.  Attempt to set an empty nickname.
    2.  **Expected Result:** Nickname not changed; an error message might appear.

*   **Test Case 5.3: Long Messages and Nicknames**
    1.  Test with very long nicknames and messages.
    2.  **Expected Result:** Widget handles them gracefully (text wraps or truncates, layout doesn't break).

*   **Test Case 5.4: Refreshing Widget Page**
    1.  **Setup:** User A and User B in chat.
    2.  **User A:** Refresh their page.
    3.  **Expected Results:**
        *   **User A's View (after refresh):** Rejoins (possibly as new guest or last set name). Sees User B. Chat history likely cleared.
        *   **User B's View:** Sees User A leave and then rejoin (as new identity).

---

**End of Test Plan**I've created a new `MANUAL_TESTING_PLAN.md` file and incorporated the detailed steps for verifying the loading state functionality into a new section: "2. Testing the Loading State".

The plan now includes:
*   **Section 1: Setup**: How to run the application (local `mix` or Docker) and access the widget.
*   **Section 2: Testing the Loading State**:
    *   **Test Case 2.1: Initial Load**: Verifies the loading indicator ("Connecting to chat..." and spinner) is shown and the main chat UI is hidden.
    *   **Test Case 2.2: Successful Connection**: Verifies the loading indicator disappears and the chat UI becomes visible and operational.
    *   **Test Case 2.3: Connection Error**: Provides methods to simulate/induce connection errors (stopping server, using dev tools to block WebSocket) and verifies the loading indicator shows an error message, hides the spinner, and the chat UI remains hidden. Also includes a code review as a fallback.
    *   **Test Case 2.4: Fast Connection Observation**: Acknowledges that the loading state might be brief on fast connections and suggests using network throttling in dev tools for better observability.
*   **Section 3: Basic Chat (Single User)**: Covers initial state post-loading, sending messages, and changing nicknames for a single user.
*   **Section 4: Multi-User Interaction**: Details tests for users joining, messaging each other, nickname changes propagating, and users leaving.
*   **Section 5: Edge Cases/Other**: Includes tests for empty messages/nicknames, long strings, and page refreshes.

This updated plan is more comprehensive and specifically addresses the loading state verification requirements.
