function zdt = getZonedDateTime(varargin)
%GETZONEDDATETIME Summary of this function goes here
%   Detailed explanation goes here

narginchk(0,1);
switch(nargin)
    case 0
        import matlab.internal.datetime.getDefaults
        [zoneStr,~] = canonicalizeTZforLocal(getDefaults('SystemTimeZone'));
    otherwise
        zoneStr = varargin{1};
end

zone = java.time.ZoneId.of(zoneStr);
a = java.time.LocalDateTime.now(zone);
zdt = a.atZone(zone);

function [canonicalTZ,tz] = canonicalizeTZforLocal(tz)
import matlab.internal.datetime.getCanonicalTZ
            
try
    % Validate a time zone to use as the local setting. getCanonicalTZ will error if
    % it's invalid, and we fall back to UTC with a warning. Tell getCanonicalTZ to
    % not warn if it's just non-standard, because many places we just need the offset.
    % But use of 'local' later on (e.g. datetime('now','TimeZone','local') will still
    % lead (once) to a warning from verifyTimeZone if the tz is non-standard.
    canonicalTZ = getCanonicalTZ(tz,false);
catch ME
    if strcmp(ME.identifier,'getZonedDateTime:canonicalizeTZforLocal:UnknownTimeZone')
        warning(message('getZonedDateTime:canonicalizeTZforLocal:InvalidSystemTimeZone',tz));
        tz = datetime.UTCZoneID;
        canonicalTZ = tz;
    else
        throwAsCaller(ME);
    end
end