//
// Created by aber tian on 2020/6/9.
//

#ifndef ACGN_CLOCK_H
#define ACGN_CLOCK_H

namespace Acgn {
    /*
     * 工作原理:
     * 1. 需要不断"对时"。 对时的方法时setClockAt(Clock &c, double pts, int serial, double time)
     *      需要用pts，serial, time(系统时间)进行对时
     * 2. 获取的时间是一个估算值， 估算是通过对 实时记录的pts_drift估算的。
     *
     * 可以看如下图来帮助理解
     *
     *         setClockAt                                   getClock
     *             |                                            |
     *             |                                            |
     *             ↓                                            ↓
     * 时间轴 ------O------------------~O~-------------------.---O-------------------~O~--------------->
     *           /  \                  /\                   /     \                 / \
     *         pts    --- pts_drift ---  time          real pts    --- pts_drift ---   time
     *
     *
     * 上图垂直中间是一个时间轴，从左往右时间连续递增，首先我们调用setClockAt进行一次对时,假设这时的pts
     * 是落后系统时间time的，那么计算pts_drift = pts - time.
     *
     * 接着， 过一会，且在下次对时前，通过getClock来查询时间，因为这时的pts已经过时了，不能直接拿pts当作这个时钟的
     * 时间，不过我们前面计算过pts_drift, 也就是pts和time的差值，所以我们可以通过当前时刻的系统时间来估算这个时刻的pts
     * 这个时刻的 pts = time + pts_drift.
     * 当然，由于pts_drifts是一直在变动的(drift与漂移抖动的意思), 所以getClock是估算值，真实的pts可能落在比如图显示的
     * real pts 位置， 也就是 句号所处的位置。
     *
     * 一般 time会取 CLOCK_MONOTONIC, 即系统开机到现在的时间， 一般都有几个小时， 而pts是节目的播放时刻，比如
     * 从0开始 播放了10分钟， 那么 pts 就是600s， 所以真实情况下pts_drift 可能要比图示的大
     * */
    class Clock {
        double pts; // clock base
        double pts_drift; // clock base minus time at which we updated the clock
        double last_updated;
        double speed;
        int serial; // clock is based on a packet with this serial
        int paused;
        int *queue_serial; // pointer to the current packet queue serial, used for obsolete clock detection

    public:
        /**
         * @param time 系统时间
         * */
        void setClockAt(Clock &c, double pts, int serial, double time);

        
    };
}


#endif //ACGN_CLOCK_H
