function [acceleration] = calc_acceleration(jointVel, time)
%calculates instantaneous accelerations from given joint velocities
time_stepsize  = time(3,1) - time(2,1);
acceleration = diff(jointVel)/time_stepsize;
acceleration = [0; acceleration];

end

