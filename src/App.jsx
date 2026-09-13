import { useEffect, useState } from 'react';
import { supabase } from './lib/supabase';

const VIDEO_URL = 'https://designerstephen.github.io/public-assets/videos/observe-hero.mp4';

export default function App() {
  const [session, setSession] = useState(null);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setSession(data.session));

    const { data: listener } = supabase.auth.onAuthStateChange((_event, nextSession) => {
      setSession(nextSession);
    });

    return () => listener.subscription.unsubscribe();
  }, []);

  async function handleLogin(event) {
    event.preventDefault();
    setLoading(true);
    setError('');

    const { error: loginError } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password,
    });

    if (loginError) setError('Email atau password tidak sesuai.');
    setLoading(false);
  }

  async function handleLogout() {
    await supabase.auth.signOut();
  }

  if (session) {
    return (
      <main className="app-shell">
        <video className="background-video" src={VIDEO_URL} muted autoPlay loop playsInline preload="auto" />
        <div className="scene-overlay" />
        <section className="authenticated-panel glass-panel">
          <div className="brand-mark">MMR</div>
          <p className="eyebrow">MOHAMMAD MUCHSIN & REKAN</p>
          <h1>Office is ready.</h1>
          <p className="muted">Login berhasil. Dashboard OSS MMR akan dibangun di ruang ini.</p>
          <button className="primary-button" onClick={handleLogout}>Keluar</button>
        </section>
      </main>
    );
  }

  return (
    <main className="app-shell">
      <video className="background-video" src={VIDEO_URL} muted autoPlay loop playsInline preload="auto" />
      <div className="scene-overlay" />

      <nav className="top-nav glass-panel">
        <div className="brand-lockup">
          <span className="brand-symbol">MM</span>
          <span>MMR OFFICE</span>
        </div>
        <span className="nav-status">INTERNAL OFFICE SYSTEM</span>
      </nav>

      <section className="login-wrap">
        <div className="login-copy">
          <p className="eyebrow">MOHAMMAD MUCHSIN & REKAN</p>
          <h1>Enter the<br /><em>office.</em></h1>
          <p className="subcopy">Sistem administrasi internal untuk mengelola surat dan agenda kantor.</p>
        </div>

        <form className="login-card glass-panel" onSubmit={handleLogin}>
          <div>
            <p className="form-label">ACCESS</p>
            <h2>Sign in</h2>
          </div>

          <label>
            Email
            <input
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              placeholder="nama@kantor.com"
              autoComplete="email"
              required
            />
          </label>

          <label>
            Password
            <input
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              placeholder="••••••••"
              autoComplete="current-password"
              required
            />
          </label>

          {error && <p className="error-message">{error}</p>}

          <button className="primary-button" type="submit" disabled={loading}>
            {loading ? 'Memverifikasi…' : 'Masuk ke Office'}
          </button>

          <p className="security-note">Akses terbatas untuk pengguna internal MMR.</p>
        </form>
      </section>

      <footer className="bottom-note">PRIVATE · MMR OFFICE · ADMINISTRATION</footer>
    </main>
  );
}
