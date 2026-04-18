import React from 'react';
import { motion } from 'framer-motion';
import { cn } from '../../lib/utils';

export const StaticAppLogo: React.FC<{className?: string, id?: string}> = ({className, id}) => (
  <svg
    id={id}
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 200 200"
    className={className}
  >
    {/* Soft Shadow */}
    <ellipse cx="100" cy="180" rx="55" ry="8" fill="currentColor" opacity="0.1" />

    {/* Film Strip Swirl (Background part) */}
    <path d="M 30 140 Q -10 90 30 40" stroke="currentColor" strokeWidth="20" fill="none" strokeLinecap="round" opacity="0.15" />

    {/* Vintage Flash Bulb */}
    <path d="M 135 60 C 145 50, 155 50, 160 55" stroke="currentColor" strokeWidth="4" fill="none" strokeLinecap="round" />
    <ellipse cx="165" cy="40" rx="18" ry="18" stroke="currentColor" strokeWidth="4" fill="var(--color-paper)" />
    {/* Flash reflector lines */}
    <path d="M 165 22 L 165 58 M 147 40 L 183 40 M 152 28 L 178 52 M 152 52 L 178 28" stroke="currentColor" strokeWidth="2" opacity="0.5" />
    {/* Little bulb */}
    <circle cx="165" cy="40" r="4" fill="currentColor" />

    {/* TLR Main Body Background */}
    <path d="M 55 50 L 145 50 L 145 170 L 55 170 Z" fill="var(--color-paper)" />

    {/* TLR Hood (Open) */}
    <path d="M 55 50 L 65 20 L 135 22 L 145 50 Z" stroke="currentColor" strokeWidth="6" fill="var(--color-paper)" strokeLinejoin="round" />
    {/* Hood internal lines for depth */}
    <path d="M 65 20 L 65 48 M 135 22 L 135 48 M 65 20 L 100 5 L 135 22" stroke="currentColor" strokeWidth="4" fill="none" strokeLinejoin="round" />

    {/* Main Body Quirky Sketch Lines */}
    <rect x="55" y="50" width="90" height="120" rx="4" stroke="currentColor" strokeWidth="6" fill="none" strokeLinecap="round" strokeLinejoin="round" />
    {/* Overlapping sketch lines to make it hand-drawn */}
    <path d="M 52 55 L 148 52 M 58 168 L 142 172 M 55 45 L 53 175 M 146 45 L 144 175" stroke="currentColor" strokeWidth="3" fill="none" strokeLinecap="round" />

    {/* Nameplate */}
    <rect x="75" y="60" width="50" height="12" rx="2" stroke="currentColor" strokeWidth="3" fill="var(--color-paper)" />
    <path d="M 80 66 Q 100 62 120 66" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" />

    {/* Viewing Lens (Top) */}
    <ellipse cx="100" cy="95" rx="20" ry="19" stroke="currentColor" strokeWidth="5" fill="var(--color-paper)" />
    <ellipse cx="99" cy="96" rx="19" ry="20" stroke="currentColor" strokeWidth="3" fill="none" />
    <circle cx="100" cy="95" r="8" fill="currentColor" />
    <path d="M 90 85 A 12 12 0 0 1 110 85" stroke="var(--color-paper)" strokeWidth="3" fill="none" strokeLinecap="round" />

    {/* Taking Lens (Bottom) */}
    <ellipse cx="100" cy="140" rx="25" ry="24" stroke="currentColor" strokeWidth="6" fill="var(--color-paper)" />
    <ellipse cx="102" cy="138" rx="24" ry="25" stroke="currentColor" strokeWidth="3" fill="none" />
    <circle cx="100" cy="140" r="12" fill="currentColor" />
    <path d="M 88 128 A 15 15 0 0 1 112 128" stroke="var(--color-paper)" strokeWidth="4" fill="none" strokeLinecap="round" />

    {/* Left Focus Knob */}
    <rect x="42" y="120" width="13" height="35" rx="3" fill="var(--color-paper)" stroke="currentColor" strokeWidth="4" />
    <path d="M 45 125 L 45 150 M 50 125 L 50 150" stroke="currentColor" strokeWidth="2" fill="none" />

    {/* Right Winding Crank */}
    <circle cx="152" cy="95" r="10" fill="var(--color-paper)" stroke="currentColor" strokeWidth="4" />
    <path d="M 152 95 L 165 105" stroke="currentColor" strokeWidth="4" strokeLinecap="round" />
    <circle cx="165" cy="105" r="4" fill="currentColor" />

    {/* Star/Sparkle accent for "memory" */}
    <path d="M 15 30 Q 25 30 25 20 Q 25 30 35 30 Q 25 30 25 40 Q 25 30 15 30" fill="currentColor" />
    <path d="M 180 140 Q 185 140 185 135 Q 185 140 190 140 Q 185 140 185 145 Q 185 140 180 140" fill="currentColor" />
  </svg>
);

export const AppLogo: React.FC<{ className?: string }> = ({ className }) => {
  return (
    <motion.div
      className={cn("text-ink", className)}
      initial={{ opacity: 0, scale: 0.8, rotate: -10 }}
      animate={{ opacity: 1, scale: 1, rotate: 0 }}
      transition={{ type: "spring", stiffness: 100, damping: 15 }}
    >
      <StaticAppLogo id="app-logo-svg" className="w-full h-full" />
    </motion.div>
  );
};
