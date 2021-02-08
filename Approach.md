# Approach

* Create two type of users, admin & non_admin. The variation can be assigned with a boolean in the user table.

* Implement Basic Auth as the login process is Username & Password based.

* Basic Auth to be implemented at PLUG level so that it eliminates the extra requests (from the user) to be handled at the PLUG level even without entering the core modules.

* Create an Events table, where in only admin can handle the event related changes. So write a PLUG authentication that will enable the users who are only admin based.

* Create an Event management table, where in users and admins can both handle the RSVP related changes to the event for a particular user. 

* Create an association with the events and the users, so that whenever any changes are happens these associations can also get updated, which reduces the load of writing extra commands.

  