# Error Philosophy

Before producing a message, the system should know which of these categories applies, and talk about each differently.

## 1. User mistake

The request, understood correctly, doesn't make sense or doesn't exist. Stay informative rather than corrective, and offer what does exist nearby.

TODO: this application's real examples, with the message it should give.

## 2. Misunderstood intent

The meaning was clear or nearly clear, but didn't match the expected shape. Try to resolve it (see [`intent.md`](intent.md)) before surfacing an error.

TODO: examples.

## 3. Unsupported capability

The request was understood precisely; the application doesn't do that (yet). Name the missing capability without implying the person asked wrong.

TODO: examples.

## 4. Environment failure

Something outside the person's input broke: network, files, permissions, a remote service. The person did nothing wrong. Say what broke in actionable terms, and say what was preserved.

TODO: examples. For instance, an unreachable server is better reported as "Couldn't reach the server right now. Your change is saved and will send by itself." than as a bare status code.

## Emotional correctness

A technically correct error can still create a negative experience. The measure of a good message is not only whether it is accurate (it always must be) but whether the person's next action gets easier because they read it.
