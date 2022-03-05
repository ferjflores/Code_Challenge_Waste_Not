# Code Challenge Project Waste Not

##Problem 1
Timer script in timer.py
###Timer Context Manager
    This script allows the user measure the running time of the specified code
####Usage:
        from timer import Timer

        with Timer():
            time.sleep(10)

    This will output to stdout: '10 second(s)'

####Passing time measure data to a dict:
A dict can be passed as an argument to the class to store 
all the data(including the raw time in seconds) from the measure

    data = {}
    with Timer(data=data):
        time.sleep(100)

Now the data dict will contain:

    {'elapsed': 100, 'elapsed_formatted': 2, 'unit': 'minute(s)'}
elapsed: Is the time in seconds.

elapsed_formatted: Is the time converted to the corresponding unit.

unit: Is the unit of time (seconds, minutes, hours).


####Append message to output
    with Timer('Custom Message to append'):
            time.sleep(10)

This will output to stdout: 'Custom Message to append   -       10 second(s)'

####Choosing the time format:
There are multiple time formats to choose for example you can get the output time in the format %H:%M:%S:%f

    data = {}
    with Timer(data=data, time_format=4):
        time.sleep(3665)

data['elapsed_formatted'] will be:
'01:01:05:0.000'


###To run tests
    python3 -m unittest problem_1/timer.py


##Problem 2
Open the file problem_2/index.html in a browser

##Problem 3
####Entity relationship diagram
problem_3/ERD.png

####Database Schema and example data
problem_3/db.sql

####Product list by customer queries
problem_3/product_list.sql





