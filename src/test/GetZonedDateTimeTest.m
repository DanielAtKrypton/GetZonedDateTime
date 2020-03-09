classdef GetZonedDateTimeTest < matlab.unittest.TestCase
    %GETZONEDDATETIMETEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant, Access = private)
        toleranceInSeconds = 5;
    end
    properties (TestParameter)
        
    end
    
    methods (Test)
        function checkGreenwichTime(testCase)
            a = webread("http://worldtimeapi.org/api/timezone/Etc/UTC");
            webDatetime = datetime(a.datetime,'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'UTC');
            zdt = getZonedDateTime('UTC');
            zdtDatetime = datetime(zdt.toEpochSecond, 'ConvertFrom', 'posixtime', 'TimeZone', 'UTC');
            testCase.assertLessThanOrEqual(abs(zdtDatetime - webDatetime), seconds(testCase.toleranceInSeconds));
        end
        function checkSystemTimeZoneTime(testCase)
            timezoneString = matlab.internal.datetime.getDefaults('SystemTimeZone');
            a = webread(['http://worldtimeapi.org/api/timezone/' timezoneString]);
            webDatetime = datetime(a.datetime,'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'UTC');
            zdt = getZonedDateTime();
            zdtDatetime = datetime(zdt.toEpochSecond, 'ConvertFrom', 'posixtime', 'TimeZone', 'UTC');
            testCase.assertLessThanOrEqual(abs(zdtDatetime - webDatetime), seconds(testCase.toleranceInSeconds));
        end        
    end
end