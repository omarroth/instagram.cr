class Instagram::Crypto
  # TODO: Decompose this into non-obfuscode
  private def self.i(e : Int32 | Nil, t : Int32)
    if !e
      return t
    end

    n = (65535 & e) + (65535 & t)
    x = (((e >> 16) + (t >> 16) + (n >> 16)) << 16) | (65535 & n)
    return x
  end

  private def self.a(e : Int32, t : Int32, n : Int32, r : Int32 | Nil, o : Int32, a : Int32)
    s = i(i(t, e), i(r, a))

    if o
      m = 32 - o
    end

    m ||= 0
    o ||= 0

    return i((s << o) | (s.to_u32 >> m.to_u32), n)
  end

  private def self.u(e, t, n, r, o, i, s)
    return a(t ^ n ^ r, e, t, o, i, s)
  end

  private def self.c(e, t, n, r, o, i, s)
    return a((t & r) | (n & ~r), e, t, o, i, s)
  end

  private def self.s(e, t, n, r, o, i, s)
    return a((t & n) | (~t & r), e, t, o, i, s)
  end

  private def self.l(e, t, n, r, o, i, s)
    return a(n ^ (t | ~r), e, t, o, i, s)
  end

  private def self.f(e)
    n = {} of Int32 => Int32
    r = 8 * e.size

    t = 0
    while t < r
      if n[t >> 5]?
        n[t >> 5] |= (255 & e[t / 8].ord) << t % 32
      else
        n[t >> 5] = (255 & e[t / 8].ord) << t % 32
      end

      t += 8
    end

    return n
  end

  private def self.d(e, t)
    if e[t >> 5]?
      e[t >> 5] |= 128 << t % 32
    else
      e[t >> 5] = 128 << t % 32
    end

    e[14 + (((t + 64).to_u32 >> 9.to_u32) << 4)] = t

    p = 1732584193
    f = -271733879
    g = -1732584194
    m = 271733878

    n = 0
    while n < e.size
      r = p
      o = f
      a = g
      d = m

      f = l(
        (f = l(
          (f = l(
            (f = l(
              (f = u(
                (f = u(
                  (f = u(
                    (f = u(
                      (f = c(
                        (f = c(
                          (f = c(
                            (f = c(
                              (f = s(
                                (f = s(
                                  (f = s(
                                    (f = s(
                                      f,
                                      (g = s(
                                        g,
                                        (m = s(
                                          m,
                                          (p = s(
                                            p,
                                            f,
                                            g,
                                            m,
                                            e[n]?,
                                            7,
                                            -680876936
                                          )),
                                          f,
                                          g,
                                          e[n + 1]?,
                                          12,
                                          -389564586
                                        )),
                                        p,
                                        f,
                                        e[n + 2]?,
                                        17,
                                        606105819
                                      )),
                                      m,
                                      p,
                                      e[n + 3]?,
                                      22,
                                      -1044525330
                                    )),
                                    (g = s(
                                      g,
                                      (m = s(
                                        m,
                                        (p = s(
                                          p,
                                          f,
                                          g,
                                          m,
                                          e[n + 4]?,
                                          7,
                                          -176418897
                                        )),
                                        f,
                                        g,
                                        e[n + 5]?,
                                        12,
                                        1200080426
                                      )),
                                      p,
                                      f,
                                      e[n + 6]?,
                                      17,
                                      -1473231341
                                    )),
                                    m,
                                    p,
                                    e[n + 7]?,
                                    22,
                                    -45705983
                                  )),
                                  (g = s(
                                    g,
                                    (m = s(
                                      m,
                                      (p = s(
                                        p,
                                        f,
                                        g,
                                        m,
                                        e[n + 8]?,
                                        7,
                                        1770035416
                                      )),
                                      f,
                                      g,
                                      e[n + 9]?,
                                      12,
                                      -1958414417
                                    )),
                                    p,
                                    f,
                                    e[n + 10]?,
                                    17,
                                    -42063
                                  )),
                                  m,
                                  p,
                                  e[n + 11]?,
                                  22,
                                  -1990404162
                                )),
                                (g = s(
                                  g,
                                  (m = s(
                                    m,
                                    (p = s(
                                      p,
                                      f,
                                      g,
                                      m,
                                      e[n + 12]?,
                                      7,
                                      1804603682
                                    )),
                                    f,
                                    g,
                                    e[n + 13]?,
                                    12,
                                    -40341101
                                  )),
                                  p,
                                  f,
                                  e[n + 14]?,
                                  17,
                                  -1502002290
                                )),
                                m,
                                p,
                                e[n + 15]?,
                                22,
                                1236535329
                              )),
                              (g = c(
                                g,
                                (m = c(
                                  m,
                                  (p = c(p, f, g, m, e[n + 1]?, 5, -165796510)),
                                  f,
                                  g,
                                  e[n + 6]?,
                                  9,
                                  -1069501632
                                )),
                                p,
                                f,
                                e[n + 11]?,
                                14,
                                643717713
                              )),
                              m,
                              p,
                              e[n]?,
                              20,
                              -373897302
                            )),
                            (g = c(
                              g,
                              (m = c(
                                m,
                                (p = c(p, f, g, m, e[n + 5]?, 5, -701558691)),
                                f,
                                g,
                                e[n + 10]?,
                                9,
                                38016083
                              )),
                              p,
                              f,
                              e[n + 15]?,
                              14,
                              -660478335
                            )),
                            m,
                            p,
                            e[n + 4]?,
                            20,
                            -405537848
                          )),
                          (g = c(
                            g,
                            (m = c(
                              m,
                              (p = c(p, f, g, m, e[n + 9]?, 5, 568446438)),
                              f,
                              g,
                              e[n + 14]?,
                              9,
                              -1019803690
                            )),
                            p,
                            f,
                            e[n + 3]?,
                            14,
                            -187363961
                          )),
                          m,
                          p,
                          e[n + 8]?,
                          20,
                          1163531501
                        )),
                        (g = c(
                          g,
                          (m = c(
                            m,
                            (p = c(p, f, g, m, e[n + 13]?, 5, -1444681467)),
                            f,
                            g,
                            e[n + 2]?,
                            9,
                            -51403784
                          )),
                          p,
                          f,
                          e[n + 7]?,
                          14,
                          1735328473
                        )),
                        m,
                        p,
                        e[n + 12]?,
                        20,
                        -1926607734
                      )),
                      (g = u(
                        g,
                        (m = u(
                          m,
                          (p = u(p, f, g, m, e[n + 5]?, 4, -378558)),
                          f,
                          g,
                          e[n + 8]?,
                          11,
                          -2022574463
                        )),
                        p,
                        f,
                        e[n + 11]?,
                        16,
                        1839030562
                      )),
                      m,
                      p,
                      e[n + 14]?,
                      23,
                      -35309556
                    )),
                    (g = u(
                      g,
                      (m = u(
                        m,
                        (p = u(p, f, g, m, e[n + 1]?, 4, -1530992060)),
                        f,
                        g,
                        e[n + 4]?,
                        11,
                        1272893353
                      )),
                      p,
                      f,
                      e[n + 7]?,
                      16,
                      -155497632
                    )),
                    m,
                    p,
                    e[n + 10]?,
                    23,
                    -1094730640
                  )),
                  (g = u(
                    g,
                    (m = u(
                      m,
                      (p = u(p, f, g, m, e[n + 13]?, 4, 681279174)),
                      f,
                      g,
                      e[n]?,
                      11,
                      -358537222
                    )),
                    p,
                    f,
                    e[n + 3]?,
                    16,
                    -722521979
                  )),
                  m,
                  p,
                  e[n + 6]?,
                  23,
                  76029189
                )),
                (g = u(
                  g,
                  (m = u(
                    m,
                    (p = u(p, f, g, m, e[n + 9]?, 4, -640364487)),
                    f,
                    g,
                    e[n + 12]?,
                    11,
                    -421815835
                  )),
                  p,
                  f,
                  e[n + 15]?,
                  16,
                  530742520
                )),
                m,
                p,
                e[n + 2]?,
                23,
                -995338651
              )),
              (g = l(
                g,
                (m = l(
                  m,
                  (p = l(p, f, g, m, e[n]?, 6, -198630844)),
                  f,
                  g,
                  e[n + 7]?,
                  10,
                  1126891415
                )),
                p,
                f,
                e[n + 14]?,
                15,
                -1416354905
              )),
              m,
              p,
              e[n + 5]?,
              21,
              -57434055
            )),
            (g = l(
              g,
              (m = l(
                m,
                (p = l(p, f, g, m, e[n + 12]?, 6, 1700485571)),
                f,
                g,
                e[n + 3]?,
                10,
                -1894986606
              )),
              p,
              f,
              e[n + 10]?,
              15,
              -1051523
            )),
            m,
            p,
            e[n + 1]?,
            21,
            -2054922799
          )),
          (g = l(
            g,
            (m = l(
              m,
              (p = l(p, f, g, m, e[n + 8]?, 6, 1873313359)),
              f,
              g,
              e[n + 15]?,
              10,
              -30611744
            )),
            p,
            f,
            e[n + 6]?,
            15,
            -1560198380
          )),
          m,
          p,
          e[n + 13]?,
          21,
          1309151649
        )),
        (g = l(
          g,
          (m = l(
            m,
            (p = l(p, f, g, m, e[n + 4]?, 6, -145523070)),
            f,
            g,
            e[n + 11]?,
            10,
            -1120210379
          )),
          p,
          f,
          e[n + 2]?,
          15,
          718787259
        )),
        m,
        p,
        e[n + 9]?,
        21,
        -343485551
      )

      p = i(p, r)
      f = i(f, o)
      g = i(g, a)
      m = i(m, d)

      n += 16
    end

    return [p, f, g, m]
  end

  private def self.p(e)
    n = ""
    r = 32 * e.size

    t = 0
    while t < r
      n += ((e[t >> 5].to_u32 >> t.to_u32 % 32) & 255).chr
      t += 8
    end

    return n
  end

  private def self.b(e)
    return p(d(f(e), 8*e.size))
  end

  private def self.g(e)
    r = ""

    n = 0
    while n < e.size
      t = e[n].ord
      r += "0123456789abcdef"[(t.to_u32 >> 4.to_u32) & 15]
      r += "0123456789abcdef"[15 & t]

      n += 1
    end

    return r
  end

  def self.sign(e : String) : String
    return g(b(e))
  end
end
