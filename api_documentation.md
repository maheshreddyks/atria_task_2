# API Endpoints

Please access all the below endpoints with the following structure.

url - > SERVER_ADDRESS:SERVER_PORT

user_type : v1 or admin

Please send the following headers in the request

```
Content-Type : application/json
```

### 1. Signup - (Admin/User)

###### POST {url}/api/{user_type}/signup

Admin/User can signup using this endpoint.

###### Input structure

|           | Mandatory | Description |
| --------- | --------- | ----------- |
| email     | yes       | email       |
| full_name | yes       | name        |
| password  | yes       | password    |
| age       | yes       | age         |



###### Input

```json
{
    "email": "mahesh@test.inn",
    "full_name": "Mahesh Reddy",
    "password": "123456",
    "age": 26
}
```

###### Output structure

|         | type    |
| ------- | ------- |
| status  | boolean |
| message | string  |
| errors  | array   |



###### Output

```json
{
    "message": "Mahesh Reddy admin signed up successfully",
    "status": true
}
```
```json
{
    "message": "Mahesh Reddy 2 user signed up successfully",
    "status": true
}
```

```json
{
    "errors": {
        "email": [
            "has already been taken"
        ]
    },
    "status": false
}
```

For all the event based endpoints, Basic Authentication has been implemented.
Please add the header 
key will be Base encode64 of username and password.
```
authorization: "Basic key"
```
### 2. Create Event - (Admin)

###### POST {url}/api/{user_type}/event/add

Admin can create an event using this endpoint.

###### Input structure

|             | type   | mandatory | description                                  |
| ----------- | ------ | --------- | -------------------------------------------- |
| date        | string | yes       | Date in ISO format in YYYY-MM-DD. Event date |
| description | string | yes       | Event Description                            |
| duration    | string | yes       | Event Duration                               |
| name        | string | yes       | Event Name                                   |
| type        | string | yes       | Event type                                   |
| host        | string | yes       | Event host                                   |



###### Input

```json
{
    "name": "Medical Event 11",
    "description": "medical description medical description medical description medical description",
    "type": "medical",
    "date": "2020-11-20",
    "duration": "45",
    "host": "Josh",
    "location": "Adams Beach"
}
```

###### Output structure

|         | type    |
| ------- | ------- |
| status  | boolean |
| message | string  |
| errors  | array   |



###### Output

```json
{
    "message": "Medical Event 11 event created successfully",
    "status": true
}
```
```json
{
    "errors": {
        "duration": [
            "is invalid"
        ]
    },
    "status": false
}
```
### 3. All Events (Admin / User)

###### GET {url}/api/{user_type}/event/list

Admin/User access all the avaialble events.

###### Output structure

|             | type    | description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | status                                                       |
| count       | integer | total event count                                            |
| events      | array   | all the events will be listed in this object                 |
| date        | string  | Date in ISO format. Event date                               |
| description | string  | Event Description                                            |
| duration    | string  | Event Duration                                               |
| event_id    | integer | Event id. This ID will be used in further operations based on events. |
| inserted_at | string  | DateTime in ISO format. Indicates when the event is created  |
| name        | string  | Event Name                                                   |
| location    | string  | Event location                                               |
| host        | string  | Event host                                                   |
| updated_at  | string  | DateTime in ISO format. Indicates when the event is last updated |



###### Output

```json
{
    "count": 2,
    "events": [
        {
            "date": "2020-11-20",
            "description": "medical description medical description medical description medical description",
            "duration": "45",
            "event_id": 1,
            "inserted_at": "2021-02-07T07:12:41",
            "location": "Adams Beach",
            "name": "Medical Event",
            "host": "Josh",
            "type": "medical",
            "updated_at": "2021-02-07T07:12:41"
        },
        {
            "date": "2020-11-20",
            "description": "medical description medical description medical description medical description",
            "duration": "45",
            "event_id": 10,
            "inserted_at": "2021-02-07T13:38:56",
            "location": "Adams Beach",
            "name": "Medical Event 11",
            "host": "Josh",
			"type": "medical",
            "updated_at": "2021-02-07T13:38:56"
        }
    ],
    "status": true
}
```
```json
{
    "count": 0,
    "events": [],
    "status": true
}
```
### 4. Update  Event - (Admin)

###### POST {url}/api/{user_type}/event/update/{event_id}

Admin can update an event using this endpoint.

###### Input structure

|             | type   | mandatory | description                                                  |
| ----------- | ------ | --------- | ------------------------------------------------------------ |
| date        | string | yes       | Date in ISO format in YYYY-MM-DD. Event date                 |
| description | string | yes       | Event Description                                            |
| duration    | string | yes       | Event Duration                                               |
| name        | string | yes       | Event Name                                                   |
| type        | string | yes       | Event type                                                   |
| host        | string | yes       | Event host                                                   |
| event_id    | string | yes       | Event_id. This id can be fetched with all events in the previous endpoint |



###### Input

```json
{
    "name": "Medical Event 2",
    "description": "medical description medical description medical description medical description",
    "type": "medical",
    "date": "2020-11-20",
    "duration": "45",
    "host": "Josh",
    "location": "Adams Beach"
}
```

###### Output structure

|         | type    |
| ------- | ------- |
| status  | boolean |
| message | string  |
| errors  | array   |



###### Output

```json
{
    "message": "Medical Event 2 event updated successfully",
    "status": true
}
```
```json
{
    "message": "Event name not available in records to update",
    "status": false
}
```

```json
{
    "errors": {
        "duration": [
            "is invalid"
        ]
    },
    "status": false
}
```

### 5. Delete Event - (Admin)

###### DELETE {url}/api/{user_type}/event/delete/{event_id}

Admin can Delete an event using this endpoint.
This will delete all the RSVP related to user who are already interested to attend

###### Input structure

|             | type   | mandatory | description                                                  |
| ----------- | ------ | --------- | ------------------------------------------------------------ |
| event_id    | string | yes       | Event_id. This id can be fetched with all events in the previous endpoint |


###### Output structure

|         | type    |
| ------- | ------- |
| status  | boolean |
| message | string  |
| errors  | array   |



###### Output

```json
{
    "message": "Medical Event 2 event deleted successfully",
    "status": true
}
```
```json
{
    "message": "Event name not available in records to delete",
    "status": false
}
```

### 6. Accept/Confirm RSVP for an Event - (User/Admin)

###### POST {url}/api/{user_type}/event/add/{event_id}

User can accept/confirm RSVP for an event using this endpoint.
This ensures that the user is an confirmed attendee to the event 

###### Input structure

|             | type   | mandatory | description                                                  |
| ----------- | ------ | --------- | ------------------------------------------------------------ |
| event_id    | string | yes       | Event_id. This id can be fetched with all events in the previous endpoint |


###### Output structure

|         | type    |
| ------- | ------- |
| status  | boolean |
| message | string  |
| errors  | array   |



###### Output
```json
{
    "message": "RSVP for event created successfully",
    "status": true
}
```

```json
{
    "message": "Event already in RSVP",
    "status": false
}
```
```json
{
    "message": "Event not available in records to accept",
    "status": false
}
```
### 7. Reject/Cancel RSVP for an Event - (User/Admin)

###### DELETE {url}/api/{user_type}/event/delete/{event_id}

User can reject/cancel RSVP for an event using this endpoint.
This ensures that the user cancelled to attend the event 

###### Input structure

|             | type   | mandatory | description                                                  |
| ----------- | ------ | --------- | ------------------------------------------------------------ |
| event_id    | string | yes       | Event_id. This id can be fetched with all events in the previous endpoint |


###### Output structure

|         | type    |
| ------- | ------- |
| status  | boolean |
| message | string  |
| errors  | array   |



###### Output
```json
{
    "message": "RSVP for event cancelled successfully",
    "status": true
}
```

```json
{
    "message": "Event already in RSVP",
    "status": false
}
```
```json
{
    "message": "Event not available in records to cancel",
    "status": false
}
```
### 8. User Confirmed Events (Admin / User)

###### GET {url}/api/{user_type}/event/list/confirmed

Admin/User can list all the events which they have confirmed.

###### Output structure

|             | type    | description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | status                                                       |
| count       | integer | total event count                                            |
| events      | array   | all the events will be listed in this object                 |
| date        | string  | Date in ISO format. Event date                               |
| description | string  | Event Description                                            |
| duration    | string  | Event Duration                                               |
| event_id    | integer | Event id. This ID will be used in further operations based on events. |
| inserted_at | string  | DateTime in ISO format. Indicates when the event is created  |
| name        | string  | Event Name                                                   |
| rsvp_status | boolean | RSVP status for the event                                    |
| location    | string  | Event location                                               |
| host        | string  | Event host                                                   |
| updated_at  | string  | DateTime in ISO format. Indicates when the event is last updated |



###### Output

```json
{
    "count": 1,
    "events": [
        {
            "date": "2020-11-20",
            "description": "medical description medical description medical description medical description",
            "duration": "45",
            "event_id": 12,
            "inserted_at": "2021-02-08T13:26:00",
            "location": "Adams Beach",
            "name": "Medical Event 11",
            "rsvp_status": true,
            "type": "medical",
            "updated_at": "2021-02-08T13:26:00"
        }
    ],
    "status": true
}
```
```json
{
    "count": 0,
    "events": [],
    "status": true
}
```
### 9. User Cancelled Events (Admin / User)

###### GET {url}/api/{user_type}/event/list/cancelled

Admin/User can list all the events which they have cancelled.

###### Output structure

|             | type    | description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | status                                                       |
| count       | integer | total event count                                            |
| events      | array   | all the events will be listed in this object                 |
| date        | string  | Date in ISO format. Event date                               |
| description | string  | Event Description                                            |
| duration    | string  | Event Duration                                               |
| event_id    | integer | Event id. This ID will be used in further operations based on events. |
| inserted_at | string  | DateTime in ISO format. Indicates when the event is created  |
| name        | string  | Event Name                                                   |
| rsvp_status | boolean | RSVP status for the event                                    |
| location    | string  | Event location                                               |
| host        | string  | Event host                                                   |
| updated_at  | string  | DateTime in ISO format. Indicates when the event is last updated |



###### Output

```json
{
    "count": 1,
    "events": [
        {
            "date": "2020-11-20",
            "description": "medical description medical description medical description medical description",
            "duration": "45",
            "event_id": 12,
            "inserted_at": "2021-02-08T13:26:00",
            "location": "Adams Beach",
            "name": "Medical Event 11",
            "rsvp_status": false,
            "type": "medical",
            "updated_at": "2021-02-08T13:26:00"
        }
    ],
    "status": true
}
```
```json
{
    "count": 0,
    "events": [],
    "status": true
}
```
### 10. Events Calendar (Admin / User)

###### GET {url}/api/{user_type}/event_calender

Admin/User can list all the events which they have confirmed sorted and grouped by date.

###### Output structure

|             | type    | description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | status                                                       |
| events      | array   | all the events will be listed in this object                 |
| date        | string  | Date in ISO format. Event date                               |
| description | string  | Event Description                                            |
| duration    | string  | Event Duration                                               |
| event_id    | integer | Event id. This ID will be used in further operations based on events. |
| inserted_at | string  | DateTime in ISO format. Indicates when the event is created  |
| name        | string  | Event Name                                                   |
| rsvp_status | boolean | RSVP status for the event                                    |
| location    | string  | Event location                                               |
| host        | string  | Event host                                                   |
| updated_at  | string  | DateTime in ISO format. Indicates when the event is last updated |



###### Output

```json
{
    "events": {
        "2020-11-20": [
            {
                "date": "2020-11-20",
                "description": "medical description medical description medical description medical description",
                "duration": "45",
                "event_id": 12,
                "inserted_at": "2021-02-08T13:26:00",
                "location": "Adams Beach",
                "name": "Medical Event 11",
                "rsvp_status": true,
                "type": "medical",
                "updated_at": "2021-02-08T13:26:00"
            }
        ]
    },
    "status": true
}
```
```json
{
    "events": [],
    "status": true
}
```
### 11. RSVP Confirmed Events (Admin)

###### GET {url}/api/{user_type}/rsvp_count/{event_id}

Admin can list all the users which they have confirmed based on the event_id.

###### Output structure

|             | type    | description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | status                                                       |
| count       | integer | total event count                                            |
| event      | oblect   | all the event details will be listed here                 |
| date        | string  | Date in ISO format. Event date                               |
| description | string  | Event Description                                            |
| duration    | string  | Event Duration                                               |
| event_id    | integer | Event id. This ID will be used in further operations based on events. |
| inserted_at | string  | DateTime in ISO format. Indicates when the event is created  |
| name        | string  | Event Name                                                   |
| rsvp_status | boolean | RSVP status for the event                                    |
| rsvp_count | array | list of RSVP's for the event |
| age | integer | Age of the user |
| email | string | Email of the user |
| full_name | string | Name of the user |
| location    | string  | Event location                                               |
| host        | string  | Event host                                                   |
| updated_at  | string  | DateTime in ISO format. Indicates when the event is last updated |



###### Output

```json
{
    "event": {
        "date": "2020-11-20",
        "description": "medical description medical description medical description medical description",
        "duration": "45",
        "event_id": 12,
        "host": "Josh",
        "inserted_at": "2021-02-08T13:26:00",
        "location": "Adams Beach",
        "name": "Medical Event 11",
        "rsvp_count": [
            {
                "age": 26,
                "email": "mahesh@test.in",
                "full_name": "Mahesh Reddy"
            }
        ],
        "rsvp_status": true,
        "updated_at": "2021-02-08T13:26:00"
    },
    "status": true
}
```
```json
{
    "message": "Event name not available to fetch RSVP count",
    "status": false
}
```
```json
{
    "message": "No RSVP's to show",
    "status": false
}
```
### 12. RSVP Cancelled Events (Admin)

###### GET {url}/api/{user_type}/rsvp_cancelled_count/{event_id}

Admin can list all the users which they have cancelled based on the event_id.

###### Output structure

|             | type    | description                                                  |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | status                                                       |
| count       | integer | total event count                                            |
| event      | oblect   | all the event details will be listed here                 |
| date        | string  | Date in ISO format. Event date                               |
| description | string  | Event Description                                            |
| duration    | string  | Event Duration                                               |
| event_id    | integer | Event id. This ID will be used in further operations based on events. |
| inserted_at | string  | DateTime in ISO format. Indicates when the event is created  |
| name        | string  | Event Name                                                   |
| rsvp_status | boolean | RSVP status for the event                                    |
| rsvp_count | array | list of RSVP's for the event |
| age | integer | Age of the user |
| email | string | Email of the user |
| full_name | string | Name of the user |
| location    | string  | Event location                                               |
| host        | string  | Event host                                                   |
| updated_at  | string  | DateTime in ISO format. Indicates when the event is last updated |



###### Output

```json
{
    "event": {
        "date": "2020-11-20",
        "description": "medical description medical description medical description medical description",
        "duration": "45",
        "event_id": 12,
        "host": "Josh",
        "inserted_at": "2021-02-08T13:26:00",
        "location": "Adams Beach",
        "name": "Medical Event 11",
        "rsvp_count": [
            {
                "age": 26,
                "email": "mahesh@test.in",
                "full_name": "Mahesh Reddy"
            }
        ],
        "rsvp_status": false,
        "updated_at": "2021-02-08T13:26:00"
    },
    "status": true
}
```
```json
{
    "message": "Event name not available to fetch RSVP count",
    "status": false
}
```
```json
{
    "message": "No RSVP's to show",
    "status": false
}
```