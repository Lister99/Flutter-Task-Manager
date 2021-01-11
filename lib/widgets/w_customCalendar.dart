// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scheduleapp/utils/u_color.dart';

//import 'date_utils.dart' as utils;

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 8.0;

const int _yearPickerColumnCount = 3;
const double _yearPickerPadding = 16.0;
const double _yearPickerRowHeight = 52.0;
const double _yearPickerRowSpacing = 8.0;

const double _subHeaderHeight = 52.0;
const double _monthNavButtonsWidth = 108.0;

class CustomCalendarDatePicker extends StatefulWidget {
  CustomCalendarDatePicker({
    Key key,
    @required DateTime initialDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    @required this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.initialCalendarMode = DatePickerMode.day,
    this.selectableDayPredicate,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        initialDate = dateOnly(initialDate),
        firstDate = dateOnly(firstDate),
        lastDate = dateOnly(lastDate),
        assert(onDateChanged != null),
        assert(initialCalendarMode != null),
        super(key: key) {
    assert(!this.lastDate.isBefore(this.firstDate),
        'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.');
    assert(!this.initialDate.isBefore(this.firstDate),
        'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.');
    assert(!this.initialDate.isAfter(this.lastDate),
        'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.');
    assert(
        selectableDayPredicate == null ||
            selectableDayPredicate(this.initialDate),
        'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.');
  }

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate selectableDayPredicate;

  @override
  _CalendarDatePickerState createState() => _CalendarDatePickerState();
}

class _CalendarDatePickerState extends State<CustomCalendarDatePicker> {
  bool _announcedInitialDate = false;
  DatePickerMode _mode;
  DateTime _currentDisplayedMonthDate;
  DateTime _selectedDate;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  MaterialLocalizations _localizations;
  TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialCalendarMode;
    _currentDisplayedMonthDate =
        DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        _localizations.formatFullDate(_selectedDate),
        _textDirection,
      );
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_mode == DatePickerMode.day) {
        SemanticsService.announce(
          _localizations.formatMonthYear(_selectedDate),
          _textDirection,
        );
      } else {
        SemanticsService.announce(
          _localizations.formatYear(_selectedDate),
          _textDirection,
        );
      }
    });
  }

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    if (value.isBefore(widget.firstDate)) {
      value = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      value = widget.lastDate;
    }

    setState(() {
      _mode = DatePickerMode.day;
      _handleMonthChanged(value);
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged?.call(_selectedDate);
    });
  }

  Widget _buildPicker() {
    assert(_mode != null);
    switch (_mode) {
      case DatePickerMode.day:
        return _MonthPicker(
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          currentDate: DateTime.now(),
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
        );
      case DatePickerMode.year:
        return Padding(
          padding: const EdgeInsets.only(top: _subHeaderHeight),
          child: _YearPicker(
            key: _yearPickerKey,
            currentDate: DateTime.now(),
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _currentDisplayedMonthDate,
            selectedDate: _selectedDate,
            onChanged: _handleYearChanged,
          ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: SizedBox(
            height: _maxDayPickerHeight,
            child: _buildPicker(),
          ),
        ),
        // Put the mode toggle button on top so that it won't be covered up by the _MonthPicker
        _DatePickerModeToggleButton(
          mode: _mode,
          title: _localizations.formatMonthYear(_currentDisplayedMonthDate),
          onTitlePressed: () {
            // Toggle the day/year mode.
            _handleModeChanged(_mode == DatePickerMode.day
                ? DatePickerMode.year
                : DatePickerMode.day);
          },
        ),
      ],
    );
  }
}

/// A button that used to toggle the [DatePickerMode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [DatePickerMode] to display either the calendar view or the year list.
class _DatePickerModeToggleButton extends StatefulWidget {
  const _DatePickerModeToggleButton({
    @required this.mode,
    @required this.title,
    @required this.onTitlePressed,
  });

  /// The current display of the calendar picker.
  final DatePickerMode mode;

  /// The text that displays the current month/year being viewed.
  final String title;

  /// The callback when the title is pressed.
  final VoidCallback onTitlePressed;

  @override
  _DatePickerModeToggleButtonState createState() =>
      _DatePickerModeToggleButtonState();
}

class _DatePickerModeToggleButtonState
    extends State<_DatePickerModeToggleButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.mode == DatePickerMode.year ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_DatePickerModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePickerMode.year) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color controlColor = colorScheme.onSurface.withOpacity(0.60);

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: _subHeaderHeight,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Semantics(
              label: 'Select year',
              excludeSemantics: true,
              button: true,
              child: Container(
                height: _subHeaderHeight,
                child: InkWell(
                  onTap: widget.onTitlePressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.subtitle2?.copyWith(
                              color: controlColor,
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: _controller,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: controlColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.mode == DatePickerMode.day)
            // Give space for the prev/next month buttons that are underneath this row
            const SizedBox(width: _monthNavButtonsWidth),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _MonthPicker({
    Key key,
    @required this.initialMonth,
    @required this.currentDate,
    @required this.firstDate,
    @required this.lastDate,
    @required this.selectedDate,
    @required this.onChanged,
    @required this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
  })  : assert(selectedDate != null),
        assert(currentDate != null),
        assert(onChanged != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate)),
        super(key: key);

  /// The initial month to display
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate selectableDayPredicate;

  @override
  State<StatefulWidget> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  DateTime _currentMonth;
  DateTime _nextMonthDate;
  DateTime _previousMonthDate;
  PageController _pageController;
  MaterialLocalizations _localizations;
  TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _previousMonthDate = addMonthsToMonthDate(_currentMonth, -1);
    _nextMonthDate = addMonthsToMonthDate(_currentMonth, 1);
    _pageController = PageController(
        initialPage: monthDelta(widget.firstDate, _currentMonth));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _handleMonthPageChanged(int monthPage) {
    final DateTime monthDate =
        addMonthsToMonthDate(widget.firstDate, monthPage);
    if (_currentMonth.year != monthDate.year ||
        _currentMonth.month != monthDate.month) {
      _currentMonth = DateTime(monthDate.year, monthDate.month);
      _previousMonthDate = addMonthsToMonthDate(_currentMonth, -1);
      _nextMonthDate = addMonthsToMonthDate(_currentMonth, 1);
      widget.onDisplayedMonthChanged?.call(_currentMonth);
    }
  }

  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      SemanticsService.announce(
        _localizations.formatMonthYear(_nextMonthDate),
        _textDirection,
      );
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      SemanticsService.announce(
        _localizations.formatMonthYear(_previousMonthDate),
        _textDirection,
      );
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month = addMonthsToMonthDate(widget.firstDate, index);
    return _DayPicker(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: widget.onChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String previousTooltipText =
        '${_localizations.previousMonthTooltip} ${_localizations.formatMonthYear(_previousMonthDate)}';
    final String nextTooltipText =
        '${_localizations.nextMonthTooltip} ${_localizations.formatMonthYear(_nextMonthDate)}';
    final Color controlColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.60);

    return Semantics(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
            height: _subHeaderHeight,
            child: Row(
              children: <Widget>[
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: controlColor,
                  tooltip: _isDisplayingFirstMonth ? null : previousTooltipText,
                  onPressed:
                      _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: controlColor,
                  tooltip: _isDisplayingLastMonth ? null : nextTooltipText,
                  onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                ),
              ],
            ),
          ),
          _DayHeaders(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: _buildItems,
              itemCount: monthDelta(widget.firstDate, widget.lastDate) + 1,
              scrollDirection: Axis.horizontal,
              onPageChanged: _handleMonthPageChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _DayPicker extends StatelessWidget {
  /// Creates a day picker.
  _DayPicker({
    Key key,
    @required this.currentDate,
    @required this.displayedMonth,
    @required this.firstDate,
    @required this.lastDate,
    @required this.selectedDate,
    @required this.onChanged,
    this.selectableDayPredicate,
  })  : assert(currentDate != null),
        assert(displayedMonth != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(selectedDate != null),
        assert(onChanged != null),
        assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate)),
        super(key: key);

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle dayStyle = textTheme.caption;
    final Color enabledDayColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledDayColor = colorScheme.onSurface.withOpacity(0.38);
    final Color selectedDayColor = Colors.white;
    final Color selectedDayBackground = MColors.buttonColor();
    final Color todayColor = MColors.buttonColor();

    final int year = displayedMonth.year;
    final int month = displayedMonth.month;

    final int daysInMonth = getDaysInMonth(year, month);
    final int dayOffset = firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = <Widget>[];
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled = dayToBuild.isAfter(lastDate) ||
            dayToBuild.isBefore(firstDate) ||
            (selectableDayPredicate != null &&
                !selectableDayPredicate(dayToBuild));

        BoxDecoration decoration;
        Color dayColor = enabledDayColor;
        final bool isSelectedDay = isSameDay(selectedDate, dayToBuild);
        if (isSelectedDay) {
          // The selected day gets a circle background highlight, and a
          // contrasting text color.
          dayColor = selectedDayColor;
          decoration = BoxDecoration(
            color: selectedDayBackground,
            shape: BoxShape.circle,
          );
        } else if (isDisabled) {
          dayColor = disabledDayColor;
        } else if (isSameDay(currentDate, dayToBuild)) {
          // The current day gets a different text color and a circle stroke
          // border.
          dayColor = todayColor;
          decoration = BoxDecoration(
            border: Border.all(color: todayColor, width: 1),
            shape: BoxShape.circle,
          );
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Text(localizations.formatDecimal(day),
                style: dayStyle.apply(color: dayColor)),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(dayToBuild),
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(_dayPickerRowHeight,
        constraints.viewportMainAxisExtent / _maxDayPickerRowCount);
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

class _DayHeaders extends StatelessWidget {
  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _getDayHeaders(
      TextStyle headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle dayHeaderStyle = theme.textTheme.caption?.apply(
      color: colorScheme.onSurface.withOpacity(0.60),
    );
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final List<Widget> labels = _getDayHeaders(dayHeaderStyle, localizations);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        shrinkWrap: true,
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          labels,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

/// A scrollable list of years to allow picking a year.
class _YearPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [currentDate, [firstDate], [lastDate], [selectedDate], and [onChanged]
  /// arguments must be non-null. The [lastDate] must be after the [firstDate].
  _YearPicker({
    Key key,
    @required this.currentDate,
    @required this.firstDate,
    @required this.lastDate,
    @required this.initialDate,
    @required this.selectedDate,
    @required this.onChanged,
  })  : assert(currentDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(initialDate != null),
        assert(selectedDate != null),
        assert(onChanged != null),
        assert(!firstDate.isAfter(lastDate)),
        super(key: key);

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The initial date to center the year display around.
  final DateTime initialDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<_YearPicker> {
  ScrollController scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();

    // Set the scroll position to approximately center the initial year.
    final int initialYearIndex =
        widget.selectedDate.year - widget.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ _yearPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    final double scrollOffset =
        _itemCount < minYears ? 0 : centeredYearRow * _yearPickerRowHeight;
    scrollController = ScrollController(initialScrollOffset: scrollOffset);
  }

  Widget _buildYearItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0;
    final int year = widget.firstDate.year + index - offset;
    final bool isSelected = year == widget.selectedDate.year;
    final bool isCurrentYear = year == widget.currentDate.year;
    final bool isDisabled =
        year < widget.firstDate.year || year > widget.lastDate.year;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    Color textColor;
    if (isSelected) {
      textColor = colorScheme.onPrimary;
    } else if (isDisabled) {
      textColor = colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentYear) {
      textColor = MColors.buttonColor();
    } else {
      textColor = colorScheme.onSurface.withOpacity(0.87);
    }
    final TextStyle itemStyle = textTheme.bodyText1?.apply(color: textColor);

    BoxDecoration decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: MColors.buttonColor(),
        borderRadius: BorderRadius.circular(decorationHeight / 2),
        shape: BoxShape.rectangle,
      );
    } else if (isCurrentYear && !isDisabled) {
      decoration = BoxDecoration(
        border: Border.all(
          color: MColors.buttonColor(),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(decorationHeight / 2),
        shape: BoxShape.rectangle,
      );
    }

    Widget yearItem = Center(
      child: Container(
        decoration: decoration,
        height: decorationHeight,
        width: decorationWidth,
        child: Center(
          child: Semantics(
            selected: isSelected,
            child: Text(year.toString(), style: itemStyle),
          ),
        ),
      ),
    );

    if (isDisabled) {
      yearItem = ExcludeSemantics(
        child: yearItem,
      );
    } else {
      yearItem = InkWell(
        key: ValueKey<int>(year),
        onTap: () {
          widget.onChanged(
            DateTime(
              year,
              widget.initialDate.month,
              widget.initialDate.day,
            ),
          );
        },
        child: yearItem,
      );
    }

    return yearItem;
  }

  int get _itemCount {
    return widget.lastDate.year - widget.firstDate.year + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Divider(),
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: _yearPickerGridDelegate,
            itemBuilder: _buildYearItem,
            itemCount: math.max(_itemCount, minYears),
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  const _YearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_yearPickerColumnCount - 1) * _yearPickerRowSpacing) /
        _yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _yearPickerRowHeight,
      crossAxisCount: _yearPickerColumnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: _yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}

const _YearPickerGridDelegate _yearPickerGridDelegate =
    _YearPickerGridDelegate();

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Common date utility functions used by the date picker implementation

// NOTE: This is an internal implementation file. Even though there are public
// classes and functions defined here, they are only meant to be used by the
// date picker implementation and are not exported as part of the Material library.
// See pickers.dart for exactly what is considered part of the public API.

//import '../material_localizations.dart';

/// Returns a [DateTime] with just the date of the original, but no time set.
DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Returns true if the two [DateTime] objects have the same day, month, and
/// year.
bool isSameDay(DateTime dateA, DateTime dateB) {
  return dateA.year == dateB.year &&
      dateA.month == dateB.month &&
      dateA.day == dateB.day;
}

/// Determines the number of months between two [DateTime] objects.
///
/// For example:
/// ```
/// DateTime date1 = DateTime(year: 2019, month: 6, day: 15);
/// DateTime date2 = DateTime(year: 2020, month: 1, day: 15);
/// int delta = monthDelta(date1, date2);
/// ```
///
/// The value for `delta` would be `7`.
int monthDelta(DateTime startDate, DateTime endDate) {
  return (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;
}

/// Returns a [DateTime] with the added number of months and truncates any day
/// and time information.
///
/// For example:
/// ```
/// DateTime date = DateTime(year: 2019, month: 1, day: 15);
/// DateTime futureDate = _addMonthsToMonthDate(date, 3);
/// ```
///
/// `date` would be January 15, 2019.
/// `futureDate` would be April 1, 2019 since it adds 3 months and truncates
/// any additional date information.
DateTime addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) {
  return DateTime(monthDate.year, monthDate.month + monthsToAdd);
}

/// Computes the offset from the first day of the week that the first day of
/// the [month] falls on.
///
/// For example, September 1, 2017 falls on a Friday, which in the calendar
/// localized for United States English appears as:
///
/// ```
/// S M T W T F S
/// _ _ _ _ _ 1 2
/// ```
///
/// The offset for the first day of the months is the number of leading blanks
/// in the calendar, i.e. 5.
///
/// The same date localized for the Russian calendar has a different offset,
/// because the first day of week is Monday rather than Sunday:
///
/// ```
/// M T W T F S S
/// _ _ _ _ 1 2 3
/// ```
///
/// So the offset is 4, rather than 5.
///
/// This code consolidates the following:
///
/// - [DateTime.weekday] provides a 1-based index into days of week, with 1
///   falling on Monday.
/// - [MaterialLocalizations.firstDayOfWeekIndex] provides a 0-based index
///   into the [MaterialLocalizations.narrowWeekdays] list.
/// - [MaterialLocalizations.narrowWeekdays] list provides localized names of
///   days of week, always starting with Sunday and ending with Saturday.
int firstDayOffset(int year, int month, MaterialLocalizations localizations) {
  // 0-based day of week for the month and year, with 0 representing Monday.
  final int weekdayFromMonday = DateTime(year, month).weekday - 1;

  // 0-based start of week depending on the locale, with 0 representing Sunday.
  int firstDayOfWeekIndex = localizations.firstDayOfWeekIndex;

  // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
  // weekdayFromMonday.
  firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

  // Number of days between the first day of week appearing on the calendar,
  // and the day corresponding to the first of the month.
  return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
}

/// Returns the number of days in a month, according to the proleptic
/// Gregorian calendar.
///
/// This applies the leap year logic introduced by the Gregorian reforms of
/// 1582. It will not give valid results for dates prior to that time.
int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear =
        (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    if (isLeapYear) return 29;
    return 28;
  }
  const List<int> daysInMonth = <int>[
    31,
    -1,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];
  return daysInMonth[month - 1];
}
