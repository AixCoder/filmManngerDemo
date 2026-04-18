import React from 'react';
import { cn } from '../../lib/utils';
import { motion } from 'framer-motion';

export interface CanisterProps {
  label: string;
  type?: string;
  className?: string;
  onClick?: () => void;
}

export const Canister: React.FC<CanisterProps> = ({ label, type = 'kodak', className, onClick }) => {
  // Determine colors based on rough generic film types
  const isFuji = type.toLowerCase().includes('fuji') || type.toLowerCase().includes('superia');
  const isBW = type.toLowerCase().includes('b/w') || type.toLowerCase().includes('hp5') || type.toLowerCase().includes('tmax');
  
  const mainColor = isFuji ? '#10b981' : isBW ? '#94a3b8' : '#facc15';
  const labelText = label.length > 10 ? label.substring(0, 10) + '...' : label;

  return (
    <motion.div 
      className={cn("group cursor-pointer flex flex-col items-center", className)}
      whileHover={{ rotate: Math.random() > 0.5 ? 3 : -3, scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      onClick={onClick}
    >
      <svg viewBox="0 0 120 140" className="w-24 h-28 drop-shadow-md" style={{ filter: 'drop-shadow(3px 3px 0px rgba(0,0,0,0.2))' }}>
        {/* Main Body */}
        <path d="M30,30 C27,30 27,110 30,110 L90,110 C93,110 93,30 90,30 Z" fill="#e5e5e5" stroke="#2a2a2a" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
        
        {/* Top Spool Cap */}
        <path d="M25,20 C25,15 95,15 95,20 L95,30 L25,30 Z" fill="#2a2a2a" stroke="#2a2a2a" strokeWidth="2" strokeLinejoin="round"/>
        <path d="M45,10 L75,10 L75,20 L45,20 Z" fill="#111" stroke="#111" strokeWidth="2" strokeLinejoin="round"/>
        <path d="M55,2 L65,2 L65,10 L55,10 Z" fill="#111"/>

        {/* Bottom Spool Cap */}
        <path d="M25,110 C25,115 95,115 95,110 L95,100 L25,100 Z" fill="#2a2a2a" stroke="#2a2a2a" strokeWidth="2" strokeLinejoin="round"/>
        <path d="M45,120 L75,120 L75,110 L45,110 Z" fill="#111" stroke="#111" strokeWidth="2" strokeLinejoin="round"/>

        {/* Film Flap Sticking out */}
        <path d="M90,50 L115,50 L115,90 L90,90 Z" fill="#444" stroke="#e0e0e0" strokeWidth="1.5" strokeDasharray="3,3"/>
        <path d="M90,50 L115,50 L115,90 L90,90 Z" fill="transparent" stroke="#2a2a2a" strokeWidth="3" strokeLinejoin="round"/>

        {/* Wrap Label */}
        <rect x="30" y="40" width="60" height="50" fill={mainColor} stroke="#2a2a2a" strokeWidth="3" strokeLinejoin="round"/>
        
        {/* Sketchy text on label */}
        <text 
          x="60" y="65" 
          fontFamily="var(--font-marker)" 
          fontSize="18" 
          textAnchor="middle" 
          fill={isBW ? '#111' : (isFuji ? '#fff' : '#d92626')} 
          fontWeight="bold" 
          transform="rotate(-4 60 65)"
        >
          {labelText.split(' ')[0] || 'FILM'}
        </text>
        <text 
          x="60" y="80" 
          fontFamily="var(--font-marker)" 
          fontSize="14" 
          textAnchor="middle" 
          fill="#111" 
          transform="rotate(-4 60 80)"
        >
          {labelText.split(' ').slice(1).join(' ') || '400'}
        </text>

        {/* Little sketchy detail lines */}
        <path d="M35,45 L40,45 M35,50 L38,50" stroke="#2a2a2a" strokeWidth="1.5" strokeLinecap="round" />
        <path d="M85,85 L85,80" stroke="#2a2a2a" strokeWidth="1.5" strokeLinecap="round" />
      </svg>
      <div className="mt-2 text-center">
        <span className="font-variant-small-caps font-bold px-2 py-1 bg-white border border-ink rough-border shadow-[1px_1px_0px_0px_#2a2a2a] text-sm transform -rotate-2 inline-block">
          {label}
        </span>
      </div>
    </motion.div>
  );
};
