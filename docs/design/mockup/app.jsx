// 지하철 푸시 — Subway alert app (pebble design)

const LINE_COLORS = {
  '1': '#0052A4', '2': '#00A84D', '3': '#EF7C1C', '4': '#00A5DE',
  '5': '#996CAC', '6': '#CD7C2F', '7': '#747F00', '8': '#E6186C',
  '9': '#BDB092', '경의중앙': '#77C4A3', '공항': '#0090D2',
  '분당': '#FABE00', '신분당': '#D4003B', '경춘': '#0C8E72',
};

const STATIONS = [
  { name: '강남', lines: ['2', '신분당'], desc: '강남구 · 환승역' },
  { name: '홍대입구', lines: ['2', '경의중앙', '공항'], desc: '마포구 · 환승역' },
  { name: '잠실', lines: ['2', '8'], desc: '송파구 · 환승역' },
  { name: '사당', lines: ['2', '4'], desc: '관악구 · 환승역' },
  { name: '서울역', lines: ['1', '4', '경의중앙', '공항'], desc: '용산구 · 환승역' },
  { name: '시청', lines: ['1', '2'], desc: '중구 · 환승역' },
  { name: '종로3가', lines: ['1', '3', '5'], desc: '종로구 · 환승역' },
  { name: '명동', lines: ['4'], desc: '중구' },
  { name: '신도림', lines: ['1', '2'], desc: '구로구 · 환승역' },
  { name: '신촌', lines: ['2'], desc: '서대문구' },
  { name: '이태원', lines: ['6'], desc: '용산구' },
  { name: '건대입구', lines: ['2', '7'], desc: '광진구 · 환승역' },
  { name: '합정', lines: ['2', '6'], desc: '마포구 · 환승역' },
  { name: '여의도', lines: ['5', '9'], desc: '영등포구 · 환승역' },
  { name: '압구정', lines: ['3'], desc: '강남구' },
  { name: '성수', lines: ['2'], desc: '성동구' },
  { name: '신사', lines: ['3', '신분당'], desc: '강남구 · 환승역' },
  { name: '교대', lines: ['2', '3'], desc: '서초구 · 환승역' },
  { name: '선릉', lines: ['2', '분당'], desc: '강남구 · 환승역' },
  { name: '삼성', lines: ['2'], desc: '강남구' },
  { name: '역삼', lines: ['2'], desc: '강남구' },
  { name: '양재', lines: ['3', '신분당'], desc: '서초구 · 환승역' },
  { name: '왕십리', lines: ['2', '5', '경의중앙', '분당'], desc: '성동구 · 환승역' },
  { name: '동대문', lines: ['1', '4'], desc: '종로구 · 환승역' },
  { name: '광화문', lines: ['5'], desc: '종로구' },
  { name: '을지로입구', lines: ['2'], desc: '중구' },
  { name: '안국', lines: ['3'], desc: '종로구' },
  { name: '혜화', lines: ['4'], desc: '종로구' },
  { name: '서울대입구', lines: ['2'], desc: '관악구' },
  { name: '강변', lines: ['2'], desc: '광진구' },
];

// ─────────────────────────────────────────────────────────────
// Subway line badge
// ─────────────────────────────────────────────────────────────
function LineBadge({ line, size = 22 }) {
  const c = LINE_COLORS[line] || '#94A3B8';
  const isNumber = /^\d+$/.test(line);
  return (
    <div style={{
      width: size, height: size, borderRadius: size / 2,
      background: c, color: '#fff',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      fontSize: isNumber ? size * 0.55 : size * 0.36,
      fontWeight: 800, letterSpacing: -0.5,
      boxShadow: `0 2px 6px ${c}55, inset 0 1px 0 rgba(255,255,255,0.3)`,
      flexShrink: 0,
      fontFamily: 'Pretendard, system-ui',
    }}>
      {isNumber ? line : line[0]}
    </div>
  );
}

function LineRow({ lines, size = 22 }) {
  return (
    <div style={{ display: 'flex', gap: 4 }}>
      {lines.map(l => <LineBadge key={l} line={l} size={size} />)}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Pebble card primitive
// ─────────────────────────────────────────────────────────────
function Pebble({ children, style = {}, onClick, active = false }) {
  return (
    <div onClick={onClick} style={{
      background: active
        ? 'linear-gradient(180deg, #EFF6FF 0%, #DBEAFE 100%)'
        : 'linear-gradient(180deg, #FFFFFF 0%, #F8FAFD 100%)',
      borderRadius: 28,
      boxShadow: active
        ? '0 1px 0 rgba(255,255,255,0.9) inset, 0 -1px 0 rgba(37,99,235,0.06) inset, 0 8px 24px rgba(37,99,235,0.12), 0 2px 6px rgba(37,99,235,0.06)'
        : '0 1px 0 rgba(255,255,255,0.9) inset, 0 -1px 0 rgba(15,23,42,0.03) inset, 0 8px 24px rgba(15,23,42,0.06), 0 2px 6px rgba(15,23,42,0.03)',
      cursor: onClick ? 'pointer' : 'default',
      transition: 'transform 0.15s ease, box-shadow 0.15s ease',
      ...style,
    }}>{children}</div>
  );
}

// ─────────────────────────────────────────────────────────────
// Home — search bar + active alerts + suggestions
// ─────────────────────────────────────────────────────────────
function AlertCard({ a, onClick, style = {} }) {
  return (
    <Pebble active onClick={onClick} style={{
      padding: '18px 20px',
      display: 'flex', alignItems: 'center', gap: 14,
      ...style,
    }}>
      <div style={{
        width: 44, height: 44, borderRadius: 22,
        background: '#fff',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        boxShadow: '0 2px 8px rgba(37,99,235,0.15)',
        flexShrink: 0,
      }}>
        <LineBadge line={a.lines[0]} size={26} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          fontSize: 17, fontWeight: 800, color: '#0F172A',
          letterSpacing: -0.6, marginBottom: 4,
        }}>{a.name}역</div>
        <div style={{
          fontSize: 12, fontWeight: 600, color: '#3B82F6',
          letterSpacing: -0.3, display: 'flex', gap: 6, alignItems: 'center',
        }}>
          {a.push && <span>🔔 푸시</span>}
          {a.vibration && <span>📳 진동</span>}
          {a.voice && <span>🔊 음성</span>}
        </div>
      </div>
      <div style={{
        width: 28, height: 28, borderRadius: 14,
        background: 'rgba(37,99,235,0.1)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0,
      }}>
        <div style={{
          width: 8, height: 8, borderRadius: 4, background: '#2563EB',
          boxShadow: '0 0 0 4px rgba(37,99,235,0.2)',
        }} />
      </div>
    </Pebble>
  );
}

function AlertStack({ alerts, onClick }) {
  const top = alerts[0];
  const count = alerts.length;
  const extras = Math.min(count - 1, 2); // 0, 1, or 2 cards peeking

  return (
    <div onClick={onClick} style={{
      position: 'relative',
      cursor: 'pointer',
      paddingBottom: extras * 8,
    }}>
      {/* Layer 2 (deepest) */}
      {extras >= 2 && (
        <div style={{
          position: 'absolute',
          left: 24, right: 24,
          top: 16, height: 60,
          background: 'linear-gradient(180deg, #C7DBFD 0%, #B5CCFB 100%)',
          borderRadius: 24,
          boxShadow: '0 6px 16px rgba(37,99,235,0.10)',
          zIndex: 1,
        }} />
      )}
      {/* Layer 1 */}
      {extras >= 1 && (
        <div style={{
          position: 'absolute',
          left: 12, right: 12,
          top: 8, height: 68,
          background: 'linear-gradient(180deg, #DCEAFE 0%, #C7DBFD 100%)',
          borderRadius: 26,
          boxShadow: '0 6px 16px rgba(37,99,235,0.10)',
          zIndex: 2,
        }} />
      )}
      {/* Top card */}
      <div style={{ position: 'relative', zIndex: 3 }}>
        <Pebble active style={{
          padding: '18px 20px',
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 22,
            background: '#fff',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: '0 2px 8px rgba(37,99,235,0.15)',
            flexShrink: 0,
          }}>
            <LineBadge line={top.lines[0]} size={26} />
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontSize: 17, fontWeight: 800, color: '#0F172A',
              letterSpacing: -0.6, marginBottom: 4,
            }}>{top.name}역</div>
            <div style={{
              fontSize: 12, fontWeight: 600, color: '#3B82F6',
              letterSpacing: -0.3, display: 'flex', gap: 6, alignItems: 'center',
            }}>
              {top.push && <span>🔔 푸시</span>}
              {top.vibration && <span>📳 진동</span>}
              {top.voice && <span>🔊 음성</span>}
            </div>
          </div>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 4,
            padding: '6px 10px 6px 12px',
            borderRadius: 16,
            background: 'linear-gradient(180deg, #DBEAFE, #BFDBFE)',
            flexShrink: 0,
          }}>
            <span style={{
              fontSize: 13, fontWeight: 800, color: '#1D4ED8',
              letterSpacing: -0.3,
            }}>+{count - 1}</span>
            <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
              <path d="M3 1l4 4-4 4" stroke="#1D4ED8" strokeWidth="2"
                strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
        </Pebble>
      </div>
    </div>
  );
}

function Home({ alerts, onSearch, onAlertTap, onAlertStackTap, nearby }) {
  return (
    <div style={{ padding: '0 20px', paddingBottom: 40 }}>
      {/* Header */}
      <div style={{ paddingTop: 64, paddingBottom: 24 }}>
        {/* Top row: app name + location chip */}
        <div style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          marginBottom: 12,
        }}>
          <div style={{
            fontSize: 14, fontWeight: 700, color: '#3B82F6',
            letterSpacing: -0.3,
          }}>지하철 푸시</div>

          <div style={{
            display: 'flex', alignItems: 'center', gap: 6,
            padding: '6px 11px 6px 8px',
            background: '#fff',
            borderRadius: 16,
            boxShadow: '0 2px 6px rgba(15,23,42,0.05), inset 0 0 0 1px rgba(15,23,42,0.04)',
          }}>
            <span style={{
              position: 'relative', display: 'inline-flex',
              width: 8, height: 8,
            }}>
              <span style={{
                position: 'absolute', inset: 0, borderRadius: 4,
                background: '#3B82F6',
                animation: 'pulse 1.8s ease-in-out infinite',
              }} />
              <span style={{
                position: 'absolute', inset: 1.5, borderRadius: 3,
                background: '#3B82F6',
              }} />
            </span>
            <span style={{
              fontSize: 11.5, fontWeight: 700, color: '#475569',
              letterSpacing: -0.3,
            }}>현재</span>
            <LineBadge line={nearby.lines[0]} size={14} />
            <span style={{
              fontSize: 11.5, fontWeight: 800, color: '#0F172A',
              letterSpacing: -0.3,
            }}>{nearby.name}</span>
          </div>
        </div>

        <div style={{
          fontSize: 30, fontWeight: 800, color: '#0F172A',
          letterSpacing: -1.2, lineHeight: 1.2,
        }}>
          푹 자도 괜찮아요,<br/>제가 깨워드릴게요
        </div>
      </div>

      {/* Search pebble — large, prominent */}
      <Pebble onClick={onSearch} style={{
        padding: '20px 22px',
        display: 'flex', alignItems: 'center', gap: 14,
        marginBottom: 28,
      }}>
        <div style={{
          width: 40, height: 40, borderRadius: 20,
          background: 'linear-gradient(135deg, #3B82F6 0%, #2563EB 100%)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(37,99,235,0.3), inset 0 1px 0 rgba(255,255,255,0.3)',
        }}>
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <circle cx="9" cy="9" r="6.5" stroke="#fff" strokeWidth="2.2"/>
            <path d="M14 14l4 4" stroke="#fff" strokeWidth="2.2" strokeLinecap="round"/>
          </svg>
        </div>
        <div style={{ flex: 1 }}>
          <div style={{
            fontSize: 16, fontWeight: 600, color: '#94A3B8',
            letterSpacing: -0.5,
          }}>역 이름을 검색해보세요</div>
        </div>
      </Pebble>

      {/* Active alerts */}
      <div style={{
        display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
        marginBottom: 14, padding: '0 4px',
      }}>
        <div style={{
          fontSize: 17, fontWeight: 800, color: '#0F172A',
          letterSpacing: -0.6,
        }}>내 알림</div>
        <div style={{
          fontSize: 13, fontWeight: 700, color: '#3B82F6',
          letterSpacing: -0.3,
        }}>{alerts.length}개 활성</div>
      </div>

      {alerts.length === 0 ? (
        <Pebble style={{
          padding: '28px 22px', marginBottom: 28,
          display: 'flex', flexDirection: 'column', alignItems: 'center',
          gap: 10, textAlign: 'center',
        }}>
          <div style={{ fontSize: 32 }}>🛏️</div>
          <div style={{
            fontSize: 14, fontWeight: 600, color: '#64748B',
            letterSpacing: -0.4, lineHeight: 1.5,
          }}>아직 설정된 알림이 없어요<br/>
            <span style={{ color: '#94A3B8', fontWeight: 500 }}>
              위에서 역을 검색해 알림을 추가하세요
            </span>
          </div>
        </Pebble>
      ) : alerts.length === 1 ? (
        <div style={{ marginBottom: 28 }}>
          <AlertCard a={alerts[0]} onClick={() => onAlertTap(alerts[0])} />
        </div>
      ) : (
        <div style={{ marginBottom: 28 }}>
          <AlertStack alerts={alerts} onClick={onAlertStackTap} />
        </div>
      )}

      {/* Popular suggestions */}
      <div style={{
        fontSize: 17, fontWeight: 800, color: '#0F172A',
        letterSpacing: -0.6, padding: '0 4px', marginBottom: 14,
      }}>자주 검색하는 역</div>

      <div style={{
        display: 'flex', gap: 8, flexWrap: 'wrap',
      }}>
        {['강남', '홍대입구', '잠실', '서울역', '사당', '신촌', '여의도'].map(name => {
          const s = STATIONS.find(x => x.name === name);
          return (
            <div key={name} onClick={() => onAlertTap(s)} style={{
              padding: '10px 14px 10px 12px',
              background: '#fff',
              borderRadius: 20,
              display: 'flex', alignItems: 'center', gap: 8,
              boxShadow: '0 2px 8px rgba(15,23,42,0.05), 0 0 0 1px rgba(15,23,42,0.04) inset',
              cursor: 'pointer',
            }}>
              <LineBadge line={s.lines[0]} size={20} />
              <span style={{
                fontSize: 14, fontWeight: 700, color: '#0F172A',
                letterSpacing: -0.4,
              }}>{name}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Search — full screen overlay with input + results
// ─────────────────────────────────────────────────────────────
function Search({ query, setQuery, onBack, onPick, alerts }) {
  const results = query.trim()
    ? STATIONS.filter(s => s.name.includes(query.trim()))
    : STATIONS.slice(0, 12);

  const inputRef = React.useRef(null);
  React.useEffect(() => { inputRef.current?.focus(); }, []);

  return (
    <div style={{
      position: 'absolute', inset: 0, background: '#F4F7FC',
      display: 'flex', flexDirection: 'column', zIndex: 20,
    }}>
      {/* Status bar spacer */}
      <div style={{ height: 60, flexShrink: 0 }} />

      {/* Search header */}
      <div style={{ padding: '8px 20px 16px', display: 'flex', gap: 10, alignItems: 'center' }}>
        <div onClick={onBack} style={{
          width: 44, height: 44, borderRadius: 22,
          background: '#fff',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 2px 8px rgba(15,23,42,0.05)',
          cursor: 'pointer', flexShrink: 0,
        }}>
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path d="M12 4l-6 6 6 6" stroke="#0F172A" strokeWidth="2.4"
              strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </div>
        <div style={{
          flex: 1, height: 48, borderRadius: 24,
          background: '#fff',
          display: 'flex', alignItems: 'center',
          padding: '0 18px', gap: 10,
          boxShadow: '0 2px 8px rgba(37,99,235,0.08), 0 0 0 2px #DBEAFE',
        }}>
          <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
            <circle cx="9" cy="9" r="6.5" stroke="#3B82F6" strokeWidth="2.2"/>
            <path d="M14 14l4 4" stroke="#3B82F6" strokeWidth="2.2" strokeLinecap="round"/>
          </svg>
          <input
            ref={inputRef}
            value={query}
            onChange={e => setQuery(e.target.value)}
            placeholder="역 이름 입력"
            style={{
              flex: 1, border: 'none', outline: 'none', background: 'transparent',
              fontSize: 16, fontWeight: 600, color: '#0F172A',
              letterSpacing: -0.5,
              fontFamily: 'Pretendard, system-ui',
            }}
          />
          {query && (
            <div onClick={() => setQuery('')} style={{
              width: 22, height: 22, borderRadius: 11,
              background: '#E2E8F0',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
            }}>
              <svg width="10" height="10" viewBox="0 0 10 10">
                <path d="M2 2l6 6M8 2l-6 6" stroke="#64748B" strokeWidth="1.8"
                  strokeLinecap="round"/>
              </svg>
            </div>
          )}
        </div>
      </div>

      {/* Results */}
      <div style={{ flex: 1, overflow: 'auto', padding: '4px 20px 40px' }}>
        {!query.trim() && (
          <div style={{
            fontSize: 13, fontWeight: 700, color: '#94A3B8',
            letterSpacing: -0.3, padding: '12px 4px 10px',
          }}>인기 검색역</div>
        )}
        {query.trim() && results.length === 0 && (
          <div style={{
            textAlign: 'center', padding: '60px 20px',
            color: '#94A3B8', fontSize: 14, fontWeight: 600,
            letterSpacing: -0.4,
          }}>
            <div style={{ fontSize: 40, marginBottom: 12 }}>🔍</div>
            검색 결과가 없어요
          </div>
        )}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {results.map(s => {
            const isActive = alerts.find(a => a.name === s.name);
            return (
              <Pebble key={s.name} onClick={() => onPick(s)} style={{
                padding: '14px 18px',
                display: 'flex', alignItems: 'center', gap: 14,
              }}>
                <LineRow lines={s.lines.slice(0, 3)} size={24} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{
                    fontSize: 16, fontWeight: 800, color: '#0F172A',
                    letterSpacing: -0.5,
                  }}>{s.name}</div>
                  <div style={{
                    fontSize: 12, fontWeight: 600, color: '#94A3B8',
                    letterSpacing: -0.3, marginTop: 2,
                  }}>{s.desc}</div>
                </div>
                {isActive && (
                  <div style={{
                    padding: '4px 10px', borderRadius: 12,
                    background: 'linear-gradient(180deg, #DBEAFE, #BFDBFE)',
                    fontSize: 11, fontWeight: 800, color: '#1D4ED8',
                    letterSpacing: -0.2,
                  }}>알림 ON</div>
                )}
              </Pebble>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Bottom sheet — set or remove alert
// ─────────────────────────────────────────────────────────────
function AlertSheet({ station, existing, onClose, onConfirm, onRemove }) {
  const [push, setPush] = React.useState(existing?.push ?? true);
  const [vibration, setVibration] = React.useState(existing?.vibration ?? true);
  const [voice, setVoice] = React.useState(existing?.voice ?? false);

  const hasAny = push || vibration || voice;

  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 40,
      display: 'flex', flexDirection: 'column', justifyContent: 'flex-end',
    }}>
      {/* Scrim */}
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0,
        background: 'rgba(15,23,42,0.35)',
        backdropFilter: 'blur(4px)',
        WebkitBackdropFilter: 'blur(4px)',
        animation: 'fadeIn 0.25s ease',
      }} />

      {/* Sheet */}
      <div style={{
        position: 'relative', zIndex: 1,
        background: 'linear-gradient(180deg, #FFFFFF 0%, #F8FAFD 100%)',
        borderTopLeftRadius: 36, borderTopRightRadius: 36,
        padding: '14px 22px 40px',
        boxShadow: '0 -10px 40px rgba(15,23,42,0.15)',
        animation: 'slideUp 0.3s cubic-bezier(0.32, 0.72, 0.3, 1)',
      }}>
        {/* Grabber */}
        <div style={{
          width: 40, height: 5, borderRadius: 3,
          background: '#CBD5E1', margin: '0 auto 16px',
        }} />

        {/* Station header */}
        <div style={{
          display: 'flex', alignItems: 'center', gap: 14, marginBottom: 24,
        }}>
          <div style={{
            width: 56, height: 56, borderRadius: 28,
            background: 'linear-gradient(180deg, #EFF6FF, #DBEAFE)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: '0 4px 12px rgba(37,99,235,0.15), inset 0 1px 0 rgba(255,255,255,0.6)',
            flexShrink: 0,
          }}>
            <LineBadge line={station.lines[0]} size={34} />
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontSize: 24, fontWeight: 800, color: '#0F172A',
              letterSpacing: -0.9, lineHeight: 1.1,
            }}>{station.name}<span style={{
              fontSize: 18, fontWeight: 700, color: '#64748B',
            }}>역</span></div>
            <div style={{
              fontSize: 12, fontWeight: 600, color: '#64748B',
              letterSpacing: -0.3, marginTop: 4,
              display: 'flex', gap: 4, alignItems: 'center',
            }}>
              <LineRow lines={station.lines} size={16} />
              <span style={{ marginLeft: 4 }}>{station.desc}</span>
            </div>
          </div>
        </div>

        {/* Section title */}
        <div style={{
          fontSize: 13, fontWeight: 700, color: '#64748B',
          letterSpacing: -0.3, marginBottom: 10, padding: '0 4px',
        }}>도착 알림 방식</div>

        {/* Toggles */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 24 }}>
          <ToggleRow
            icon="🔔" label="푸시 알림"
            sub="잠금화면과 알림센터에 표시"
            value={push} onChange={setPush}
          />
          <ToggleRow
            icon="📳" label="진동"
            sub="3회 길게 진동해요"
            value={vibration} onChange={setVibration}
          />
          <ToggleRow
            icon="🔊" label="음성 안내"
            sub='"잠실역에 도착했습니다" 음성 재생'
            value={voice} onChange={setVoice}
          />
        </div>

        {/* Actions */}
        {existing ? (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <button onClick={() => onConfirm({ push, vibration, voice })}
              disabled={!hasAny}
              style={primaryBtn(hasAny)}>
              변경사항 저장
            </button>
            <button onClick={onRemove} style={dangerBtn()}>
              알림 해제하기
            </button>
          </div>
        ) : (
          <button onClick={() => onConfirm({ push, vibration, voice })}
            disabled={!hasAny}
            style={primaryBtn(hasAny)}>
            알림 설정 완료
          </button>
        )}
      </div>
    </div>
  );
}

function primaryBtn(enabled) {
  return {
    width: '100%', height: 58, borderRadius: 24, border: 'none',
    background: enabled
      ? 'linear-gradient(180deg, #3B82F6 0%, #2563EB 100%)'
      : 'linear-gradient(180deg, #CBD5E1, #94A3B8)',
    color: '#fff', fontSize: 17, fontWeight: 800, letterSpacing: -0.5,
    fontFamily: 'Pretendard, system-ui',
    cursor: enabled ? 'pointer' : 'not-allowed',
    boxShadow: enabled
      ? '0 6px 20px rgba(37,99,235,0.35), inset 0 1px 0 rgba(255,255,255,0.3)'
      : 'none',
    transition: 'transform 0.1s',
  };
}

function dangerBtn() {
  return {
    width: '100%', height: 52, borderRadius: 22, border: 'none',
    background: '#FEE2E2',
    color: '#DC2626', fontSize: 15, fontWeight: 800, letterSpacing: -0.4,
    fontFamily: 'Pretendard, system-ui',
    cursor: 'pointer',
    boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.6)',
  };
}

function ToggleRow({ icon, label, sub, value, onChange }) {
  return (
    <div onClick={() => onChange(!value)} style={{
      display: 'flex', alignItems: 'center', gap: 14,
      padding: '14px 16px',
      background: value
        ? 'linear-gradient(180deg, #EFF6FF, #E0EBFE)'
        : '#F8FAFC',
      borderRadius: 22,
      boxShadow: value
        ? 'inset 0 0 0 1.5px rgba(59,130,246,0.25)'
        : 'inset 0 0 0 1px rgba(15,23,42,0.05)',
      cursor: 'pointer',
      transition: 'all 0.2s',
    }}>
      <div style={{
        width: 40, height: 40, borderRadius: 20,
        background: value ? '#fff' : '#F1F5F9',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 20, flexShrink: 0,
        boxShadow: value ? '0 2px 6px rgba(37,99,235,0.15)' : 'none',
      }}>{icon}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          fontSize: 15, fontWeight: 800,
          color: value ? '#1D4ED8' : '#0F172A',
          letterSpacing: -0.5,
        }}>{label}</div>
        <div style={{
          fontSize: 12, fontWeight: 600,
          color: value ? '#3B82F6' : '#94A3B8',
          letterSpacing: -0.3, marginTop: 2,
        }}>{sub}</div>
      </div>
      <Switch value={value} />
    </div>
  );
}

function Switch({ value }) {
  return (
    <div style={{
      width: 48, height: 30, borderRadius: 15,
      background: value
        ? 'linear-gradient(180deg, #3B82F6, #2563EB)'
        : '#CBD5E1',
      position: 'relative',
      transition: 'background 0.2s',
      flexShrink: 0,
      boxShadow: value
        ? 'inset 0 1px 2px rgba(0,0,0,0.1)'
        : 'inset 0 1px 2px rgba(0,0,0,0.08)',
    }}>
      <div style={{
        position: 'absolute',
        top: 2, left: value ? 20 : 2,
        width: 26, height: 26, borderRadius: 13,
        background: '#fff',
        transition: 'left 0.2s cubic-bezier(0.32, 0.72, 0.3, 1)',
        boxShadow: '0 2px 4px rgba(0,0,0,0.15), 0 1px 2px rgba(0,0,0,0.1)',
      }} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Alert list sheet
// ─────────────────────────────────────────────────────────────
function AlertListSheet({ alerts, onClose, onPick }) {
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 40,
      display: 'flex', flexDirection: 'column', justifyContent: 'flex-end',
    }}>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0,
        background: 'rgba(15,23,42,0.35)',
        backdropFilter: 'blur(4px)',
        WebkitBackdropFilter: 'blur(4px)',
        animation: 'fadeIn 0.25s ease',
      }} />

      <div style={{
        position: 'relative', zIndex: 1,
        background: 'linear-gradient(180deg, #FFFFFF 0%, #F8FAFD 100%)',
        borderTopLeftRadius: 36, borderTopRightRadius: 36,
        padding: '14px 22px 30px',
        boxShadow: '0 -10px 40px rgba(15,23,42,0.15)',
        animation: 'slideUp 0.3s cubic-bezier(0.32, 0.72, 0.3, 1)',
        maxHeight: '78%',
        display: 'flex', flexDirection: 'column',
      }}>
        <div style={{
          width: 40, height: 5, borderRadius: 3,
          background: '#CBD5E1', margin: '0 auto 18px',
          flexShrink: 0,
        }} />

        <div style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
          padding: '0 4px 14px',
          flexShrink: 0,
        }}>
          <div style={{
            fontSize: 22, fontWeight: 800, color: '#0F172A',
            letterSpacing: -0.8,
          }}>설정된 알림</div>
          <div style={{
            fontSize: 13, fontWeight: 700, color: '#3B82F6',
            letterSpacing: -0.3,
          }}>{alerts.length}개</div>
        </div>

        <div style={{
          overflowY: 'auto',
          display: 'flex', flexDirection: 'column', gap: 10,
          margin: '0 -4px', padding: '0 4px 6px',
        }}>
          {alerts.map(a => (
            <Pebble key={a.name} active onClick={() => onPick(a)} style={{
              padding: '14px 18px',
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{
                width: 40, height: 40, borderRadius: 20,
                background: '#fff',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                boxShadow: '0 2px 6px rgba(37,99,235,0.12)',
                flexShrink: 0,
              }}>
                <LineBadge line={a.lines[0]} size={24} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{
                  fontSize: 16, fontWeight: 800, color: '#0F172A',
                  letterSpacing: -0.5, marginBottom: 3,
                }}>{a.name}역</div>
                <div style={{
                  fontSize: 11.5, fontWeight: 600, color: '#3B82F6',
                  letterSpacing: -0.3, display: 'flex', gap: 6,
                }}>
                  {a.push && <span>🔔 푸시</span>}
                  {a.vibration && <span>📳 진동</span>}
                  {a.voice && <span>🔊 음성</span>}
                </div>
              </div>
              <svg width="8" height="14" viewBox="0 0 8 14" style={{ flexShrink: 0 }}>
                <path d="M1 1l6 6-6 6" stroke="#94A3B8" strokeWidth="2" fill="none"
                  strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </Pebble>
          ))}
        </div>
      </div>
    </div>
  );
}

// Toast
// ─────────────────────────────────────────────────────────────
function Toast({ children }) {
  return (
    <div style={{
      position: 'absolute', top: 80, left: '50%',
      transform: 'translateX(-50%)',
      zIndex: 50,
      padding: '12px 20px',
      borderRadius: 24,
      background: 'linear-gradient(180deg, #0F172A, #1E293B)',
      color: '#fff', fontSize: 14, fontWeight: 700,
      letterSpacing: -0.4,
      boxShadow: '0 8px 24px rgba(15,23,42,0.3)',
      animation: 'toastIn 0.3s cubic-bezier(0.32, 0.72, 0.3, 1)',
      display: 'flex', alignItems: 'center', gap: 8,
      whiteSpace: 'nowrap',
    }}>{children}</div>
  );
}

// ─────────────────────────────────────────────────────────────
// Root App
// ─────────────────────────────────────────────────────────────
function App() {
  const [screen, setScreen] = React.useState('home');
  const [query, setQuery] = React.useState('');
  const [sheetStation, setSheetStation] = React.useState(null);
  const [showAlertList, setShowAlertList] = React.useState(false);
  const [alerts, setAlerts] = React.useState([
    { name: '잠실', lines: ['2', '8'], desc: '송파구 · 환승역',
      push: true, vibration: true, voice: false },
    { name: '강남', lines: ['2', '신분당'], desc: '강남구 · 환승역',
      push: true, vibration: false, voice: false },
    { name: '서울역', lines: ['1', '4', '경의중앙', '공항'], desc: '용산구 · 환승역',
      push: true, vibration: true, voice: true },
  ]);
  const [toast, setToast] = React.useState(null);

  React.useEffect(() => {
    if (!toast) return;
    const t = setTimeout(() => setToast(null), 1800);
    return () => clearTimeout(t);
  }, [toast]);

  const existingAlert = sheetStation
    ? alerts.find(a => a.name === sheetStation.name)
    : null;

  function handleConfirm(opts) {
    const merged = { ...sheetStation, ...opts };
    setAlerts(prev => {
      const others = prev.filter(a => a.name !== sheetStation.name);
      return [merged, ...others];
    });
    setSheetStation(null);
    setQuery('');
    setScreen('home');
    setToast({ type: 'ok', msg: `${sheetStation.name}역 알림 ${existingAlert ? '변경' : '설정'} 완료` });
  }

  function handleRemove() {
    setAlerts(prev => prev.filter(a => a.name !== sheetStation.name));
    setSheetStation(null);
    setToast({ type: 'off', msg: `${sheetStation.name}역 알림이 해제됐어요` });
  }

  return (
    <div style={{
      width: '100%', height: '100%', position: 'relative',
      background: 'radial-gradient(ellipse 80% 50% at 50% 0%, #E0EBFE 0%, #F4F7FC 60%)',
      overflow: 'hidden',
      fontFamily: 'Pretendard, system-ui',
    }}>
      {/* HOME content */}
      <div style={{
        width: '100%', height: '100%', overflow: 'auto',
        opacity: screen === 'home' ? 1 : 0,
        transition: 'opacity 0.2s',
      }}>
        <Home
          alerts={alerts}
          onSearch={() => setScreen('search')}
          onAlertTap={(s) => setSheetStation(s)}
          onAlertStackTap={() => setShowAlertList(true)}
          nearby={STATIONS.find(s => s.name === '강남')}
        />
      </div>

      {/* SEARCH overlay */}
      {screen === 'search' && (
        <Search
          query={query} setQuery={setQuery}
          onBack={() => { setQuery(''); setScreen('home'); }}
          onPick={(s) => setSheetStation(s)}
          alerts={alerts}
        />
      )}

      {/* ALERT LIST sheet */}
      {showAlertList && (
        <AlertListSheet
          alerts={alerts}
          onClose={() => setShowAlertList(false)}
          onPick={(a) => {
            setShowAlertList(false);
            setSheetStation(a);
          }}
        />
      )}

      {/* SHEET */}
      {sheetStation && (
        <AlertSheet
          station={sheetStation}
          existing={existingAlert}
          onClose={() => setSheetStation(null)}
          onConfirm={handleConfirm}
          onRemove={handleRemove}
        />
      )}

      {/* TOAST */}
      {toast && (
        <Toast>
          <span style={{ fontSize: 16 }}>{toast.type === 'ok' ? '✅' : '🌙'}</span>
          {toast.msg}
        </Toast>
      )}
    </div>
  );
}

Object.assign(window, { App });
