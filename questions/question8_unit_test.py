from datetime import datetime
from enum import Enum
from statistics import mean

import pytest


class GroupByEnum(Enum):
    HOUR = 'hour'
    DAY = 'day'


def process_data(data_list, group_by: GroupByEnum):
    if not isinstance(group_by, GroupByEnum):
        raise ValueError(
            f'Invalid group_by: {group_by}. Must be an instance of GroupByEnum.')

    grouped_data = {}
    for item in data_list:
        value = item.get("value")
        measure_at = item.get("measure_at")
        if value is None or measure_at is None:
            continue

        measure_at_dt = datetime.fromisoformat(measure_at)

        if group_by == GroupByEnum.HOUR:
            group_key = measure_at_dt.replace(
                minute=0, second=0, microsecond=0)
        else:
            group_key = measure_at_dt.replace(
                hour=0, minute=0, second=0, microsecond=0)

        if group_key not in grouped_data:
            grouped_data[group_key] = []
        grouped_data[group_key].append(value)

    result = {}
    for group_key, values in grouped_data.items():
        result[group_key] = {
            'average': mean(values),
            'sum': sum(values),
            'max': max(values),
            'min': min(values),
        }

    return result


def test_valid_data_hour():
    data_list = [
        {"value": 10, "measure_at": "2023-01-01T01:00:00"},
        {"value": 20, "measure_at": "2023-01-01T01:30:00"},
        {"value": 30, "measure_at": "2023-01-01T02:00:00"}
    ]

    result = process_data(data_list, GroupByEnum.HOUR)

    expected = {
        datetime(2023, 1, 1, 1): {
            'average': 15, 'sum': 30, 'max': 20, 'min': 10
        },
        datetime(2023, 1, 1, 2): {
            'average': 30, 'sum': 30, 'max': 30, 'min': 30
        }
    }

    assert result == expected


def test_valid_data_day():
    data_list = [
        {"value": 10, "measure_at": "2023-01-01T01:00:00"},
        {"value": 20, "measure_at": "2023-01-01T13:00:00"},
        {"value": 30, "measure_at": "2023-01-02T02:00:00"}
    ]

    result = process_data(data_list, GroupByEnum.DAY)

    expected = {
        datetime(2023, 1, 1): {
            'average': 15, 'sum': 30, 'max': 20, 'min': 10
        },
        datetime(2023, 1, 2): {
            'average': 30, 'sum': 30, 'max': 30, 'min': 30}
    }

    assert result == expected


def test_invalid_group_by():
    data_list = [{"value": 10, "measure_at": "2023-01-01T01:00:00"}]

    with pytest.raises(ValueError) as exec_info:
        process_data(data_list, 'invalid')

    assert str(exec_info.value) == 'Invalid group_by: invalid. Must be an instance of GroupByEnum.'


def test_missing_fields():
    data_list = [
        {"value": 10, "measure_at": "2023-01-01T01:00:00"},
        {"measure_at": "2023-01-01T01:30:00"},
        {"value": 30}
    ]
    result = process_data(data_list, GroupByEnum.HOUR)

    expected = {
        datetime(2023, 1, 1, 1): {
            'average': 10, 'sum': 10, 'max': 10, 'min': 10}
    }

    assert result == expected
