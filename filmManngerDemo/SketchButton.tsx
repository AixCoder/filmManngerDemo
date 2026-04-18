import React from 'react';
import { cn } from '../../lib/utils';
import { motion, HTMLMotionProps } from 'framer-motion';

export interface ButtonProps extends HTMLMotionProps<"button"> {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
}

export const SketchButton = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'primary', size = 'md', ...props }, ref) => {
    
    const variants = {
      primary: 'bg-yellow-200 text-ink hover:bg-yellow-300',
      secondary: 'bg-paper text-ink hover:bg-gray-100',
      danger: 'bg-red-200 text-ink hover:bg-red-300',
    }
    
    const sizes = {
      sm: 'px-3 py-1 text-sm',
      md: 'px-5 py-2 text-base',
      lg: 'px-8 py-3 text-lg',
    }

    return (
      <motion.button
        ref={ref}
        whileHover={{ scale: 1.02, y: -2 }}
        whileTap={{ scale: 0.98, y: 2 }}
        className={cn(
          "relative inline-flex items-center justify-center font-bold tracking-wider",
          "border-2 border-ink rough-border",
          "shadow-[3px_3px_0px_0px_rgba(42,42,42,1)] hover:shadow-[4px_4px_0px_0px_rgba(42,42,42,1)] active:shadow-none",
          "transition-colors duration-200",
          variants[variant],
          sizes[size],
          className
        )}
        {...props}
      />
    );
  }
);
SketchButton.displayName = 'SketchButton';
