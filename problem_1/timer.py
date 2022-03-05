"""Timer Context Manager
    This script allows the user measure the running time of the specified code
    **Usage:
        from timer import Timer

        with Timer():
            time.sleep(10)

    This will output to stdout: '10 second(s)'

    **Passing time measure data to a dict:
    A dict can be passed as an argument to the class to store all the data(including the raw time in seconds) from the
    measure
        data = {}
        with Timer(data=data):
            time.sleep(100)

    Now the data dict will contain:
    {'elapsed': 100, 'elapsed_formatted': 2, 'unit': 'minute(s)'}
    elapsed: Is the time in seconds.
    elapsed_formatted: Is the time converted to the corresponding unit.
    unit: Is the unit of time (seconds, minutes, hours).

    **Append message to output
    with Timer('Custom Message to append'):
            time.sleep(10)

    This will output to stdout: 'Custom Message to append   -       10 second(s)'

    **Choosing the time format:
    There are multiple time formats to choose for example you can get the output time in the format %H:%M:%S:%f

        data = {}
        with Timer(data=data, time_format=4):
            time.sleep(3665)

    data['elapsed_formatted'] will be:
    '01:01:05:0.000'

"""
import io
import sys
import time
import unittest
from typing import Union
from unittest.mock import patch
from dataclasses import dataclass


class TimerException(Exception):
    pass


@dataclass
class Timer:
    """
       A class used as a Context Manager to measure the running time of a function

        Args:
            text (str):  Message to append to the printed output
            data (dict): Dict to store the measure timing data.
            time_format (int): The format selected for timing data
                possible values:
                0: Timing measure returned in seconds without rounding
                1: Timing measure returned (multiple units) rounded with not decimals
                2: Timing measure returned (multiple units) rounded with two decimals
                3: Timing measure returned (multiple units) without rounding
                4: Timing measure returned in format (%H:%M:%S:%f)
            output (bool): Boolean that indicates if the result should be printed to stdout
       """

    text: str = None
    data: dict = None
    time_format: int = 1
    output: bool = True

    def __post_init__(self):
        if self.data is None and self.output is False:
            raise TimerException('data argument should be passed or output argument must be True')
        if self.data is not None and not isinstance(self.data, dict):
            raise TimerException('data argument should be a dict instance')

    def __round(self, elapsed_seconds: float) -> (float, Union[str, float], str, str):
        """
        Return a formatted the elapsed_seconds, the decimal format and the time unit name
        according to the time_format selected
        Args:
            elapsed_seconds (float): the timing measure in seconds to be formatted

        Returns:
            A tuple containing the formatted time, the format for the decimal part
            and the time unit (ex: seconds, hours...)
        """

        decimal_format = ''
        unit = ''
        formatted_time = elapsed_seconds
        if self.time_format == 0:
            unit = 'second(s)'
        elif self.time_format == 1:
            decimal_format = '.0f'
            elapsed_seconds, unit = self.__convert_unit(elapsed_seconds)
            formatted_time = round(elapsed_seconds, 0)
        elif self.time_format == 2:
            decimal_format = '.2f'
            elapsed_seconds, unit = self.__convert_unit(elapsed_seconds)
            formatted_time = round(elapsed_seconds, 2)
        elif self.time_format == 3:
            elapsed_seconds, unit = self.__convert_unit(elapsed_seconds)
        elif self.time_format == 4:
            if elapsed_seconds > 24 * 3600:
                raise TimerException()
            formatted_time = time.strftime(f'%H:%M:%S:{elapsed_seconds % 1 * 1000:.3f}', time.gmtime(elapsed_seconds))
        return elapsed_seconds, formatted_time, decimal_format, unit

    @staticmethod
    def __convert_unit(seconds) -> (float, str):
        """
        Return the measure time in seconds converted to another time unit according to the given conditions
        (ex: if the time is bigger than 3600 sec will return the time in hours)

        Args:
            seconds (float): The timing measure in seconds

        Returns:
            A tuple containing the converted measure and the corresponding unit
        """
        unit = 'second(s)'
        if seconds < 1:
            return seconds * 1000, 'millisecond(s)'
        elif 60 > seconds > 1:
            return seconds, unit
        elif 3600 > seconds > 59:
            return seconds / 60, 'minute(s)'
        else:
            return seconds / 3600, 'hour(s)'

    def __enter__(self) -> None:
        """
        Set start time to measure the running time of the code inside the context
        """
        self.start = time.monotonic()

    def __exit__(self, exc_type: type, exc_value: Exception, exc_traceback: object) -> None:
        """
        Set the stop time and calculate elapsed time running the code inside the context,
        if selected will print to the stdout the timing measure with its unit

        Args:
            exception_type (type): indicates class of exception.
            exception_value (Exception): indicates type of exception.
            exception_traceback (traceback): traceback is a report which has all the information needed to solve
                the exception.
        """
        self.stop = time.monotonic()
        elapsed, elapsed_formatted, decimal_format, unit = self.__round(self.stop - self.start)
        if isinstance(self.data, dict):
            self.data['elapsed'] = elapsed
            self.data['elapsed_formatted'] = elapsed_formatted
            self.data['unit'] = unit

        if self.output:
            message = ''
            if self.text:
                message = f'{self.text}\t - \t\t\t '
            print(f'{message}{elapsed_formatted:{decimal_format}} {unit}')


class TestTimer(unittest.TestCase):
    """
    Test cases for the class Timer
    """
    def test_timer(self):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data, output=True):
            time.sleep(2)
        self.assertEqual(data['elapsed_formatted'], 2)
        self.assertGreater(data['elapsed'], 2)
        self.assertEqual(data['unit'], 'second(s)')
        self.assertEqual(round(data['elapsed']), 2)
        self.assertIn('2 second(s)', captured_output.getvalue())

    def test_timer_data(self):
        data = {}
        with Timer('Test message', data=data, output=False):
            time.sleep(2)
        self.assertEqual(data['elapsed_formatted'], 2)
        self.assertEqual(data['unit'], 'second(s)')
        self.assertGreater(data['elapsed'], 2)
        self.assertEqual(round(data['elapsed']), 2)

    def test_timer_output(self):
        captured_output = io.StringIO()
        sys.stdout = captured_output

        with Timer('Test message'):
            time.sleep(2)
        self.assertIn('2 second(s)', captured_output.getvalue())

    def test_timer__not_data__not_output(self):
        with self.assertRaises(TimerException), Timer('Test message', output=False):
            time.sleep(2)

    @patch('time.sleep', return_value=None)
    @patch('time.monotonic', side_effect=[0, 0.023])
    def test_timer_milliseconds(self, patched_time_sleep, patched_time_monotonic):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data):
            time.sleep(500)
        self.assertEqual(data['elapsed_formatted'], 23)
        self.assertEqual(data['elapsed'], 23)
        self.assertEqual(data['unit'], 'millisecond(s)')
        self.assertIn('23 millisecond(s)', captured_output.getvalue())

    @patch('time.sleep', return_value=None)
    @patch('time.monotonic', side_effect=[0, 500])
    def test_timer_seconds(self, patched_time_sleep, patched_time_monotonic):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data, time_format=0):
            time.sleep(500)
        self.assertEqual(data['elapsed_formatted'], 500)
        self.assertEqual(data['elapsed'], 500)
        self.assertEqual(data['unit'], 'second(s)')
        self.assertIn('500 second(s)', captured_output.getvalue())

    @patch('time.sleep', return_value=None)
    @patch('time.monotonic', side_effect=[0, 500])
    def test_timer_minutes(self, patched_time_sleep, patched_time_monotonic):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data):
            time.sleep(500)

        self.assertEqual(data['elapsed_formatted'], 8)
        self.assertGreater(data['elapsed'], 8)
        self.assertEqual(round(data['elapsed']), 8)
        self.assertEqual(data['unit'], 'minute(s)')
        self.assertIn('8 minute(s)', captured_output.getvalue())

    @patch('time.sleep', return_value=None)
    @patch('time.monotonic', side_effect=[0, 7200])
    def test_timer_hours(self, patched_time_sleep, patched_time_monotonic):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data):
            time.sleep(7200)

        self.assertEqual(data['elapsed_formatted'], 2)
        self.assertEqual(data['elapsed'], 2)
        self.assertEqual(data['unit'], 'hour(s)')
        self.assertIn('2 hour(s)', captured_output.getvalue())

    @patch('time.sleep', return_value=None)
    def test_timer__2_decimals(self, patched_time_sleep):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with patch('time.monotonic', side_effect=[0, 1.53232]), Timer('Test message', data=data, time_format=2):
            time.sleep(1.53232)

        self.assertEqual(data['elapsed_formatted'], 1.53)
        self.assertEqual(data['elapsed'], 1.53232)
        self.assertEqual(data['unit'], 'second(s)')
        self.assertIn('1.53 second(s)', captured_output.getvalue())

        with patch('time.monotonic', side_effect=[0, 8450]), Timer('Test message', data=data, time_format=2):
            time.sleep(8450)

        self.assertEqual(data['elapsed_formatted'], 2.35)
        self.assertEqual(data['elapsed'], 2.3472222222222223)
        self.assertEqual(data['unit'], 'hour(s)')
        self.assertIn('2.35 hour(s)', captured_output.getvalue())

    @patch('time.sleep', return_value=None)
    @patch('time.monotonic', side_effect=[0, 1.5323652])
    def test_timer__all_decimals(self, patched_time_sleep, patched_time_monotonic):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data, time_format=3):
            time.sleep(1.5323652)

        self.assertEqual(data['elapsed_formatted'], 1.5323652)
        self.assertEqual(data['elapsed'], 1.5323652)
        self.assertEqual(data['unit'], 'second(s)')
        self.assertIn('1.5323652 second(s)', captured_output.getvalue())

    @patch('time.sleep', return_value=None)
    @patch('time.monotonic', side_effect=[0, 9544.2323])
    def test_timer__hour_minutes_seconds(self, patched_time_sleep, patched_time_monotonic):
        captured_output = io.StringIO()
        sys.stdout = captured_output
        data = {}
        with Timer('Test message', data=data, time_format=4):
            time.sleep(9544.2323)

        self.assertEqual(data['elapsed_formatted'], '02:39:04:232.300')
        self.assertEqual(data['elapsed'], 9544.2323)
        self.assertEqual(data['unit'], '')
        self.assertIn('02:39:04:232.300', captured_output.getvalue())

    def test_time__data_non_dict(self):
        data = []
        with self.assertRaises(TimerException) as context, Timer('Test message', data=data, output=False):
            time.sleep(2)
        self.assertEqual(str(context.exception), 'data argument should be a dict instance')


if __name__ == '__main__':
    unittest.main()
