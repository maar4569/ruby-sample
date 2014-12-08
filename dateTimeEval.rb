require 'date'
module DateTimeEval
  #date dt_l,dt_r
  #return negative => dt_r is latest then dt_l
  #return positive => dt_l is latest then dt_r
  def compTime( dt_l , dt_r )
    begin
      tm_l = epochTimeFromDate( dt_l )
      tm_r = epochTimeFromDate( dt_r )
    rescue => e
    p "compTime exception"
    p e
    end
    return tm_l.to_i - tm_r.to_i
  end
  def epochTimeFromDate( dt )
    begin
      tm = Time.local( dt.year,dt.mon,dt.day,dt.hour,dt.min,dt.sec )
    rescue => e
      p "epochTimeFromDate Exception"
      p e
    end
    return tm.to_i
  end
  module_function :compTime
  module_function :epochTimeFromDate
end

include DateTimeEval
test1="2014-12-03T07:00:36+9:00"
test2="2014-12-05T07:00:36+9:00"
p DateTimeEval.compTime(DateTime.parse(test1),DateTime.parse(test2))
